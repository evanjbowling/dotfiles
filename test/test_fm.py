"""
Tests for bin/fm

Extracts YAML frontmatter from a markdown file. Output includes both
delimiters (--- or ...) and the content between them. Body content after
the closing delimiter is not printed. Accepts exactly one argument.
"""

import subprocess
import unittest
from pathlib import Path

REPO_ROOT = Path(__file__).parent.parent
BIN = REPO_ROOT / "bin" / "fm"
FIXTURES = Path(__file__).parent / "fixtures" / "fm"


def run(*args):
    return subprocess.run(
        [str(BIN), *args],
        capture_output=True,
        text=True,
    )


class TestFmWithFrontmatter(unittest.TestCase):
    def test_exits_zero(self):
        r = run(str(FIXTURES / "with_frontmatter.md"))
        self.assertEqual(r.returncode, 0)

    def test_includes_opening_delimiter(self):
        r = run(str(FIXTURES / "with_frontmatter.md"))
        self.assertIn("---", r.stdout)

    def test_includes_frontmatter_fields(self):
        r = run(str(FIXTURES / "with_frontmatter.md"))
        self.assertIn("title: Hello World", r.stdout)
        self.assertIn("date: 2024-01-01", r.stdout)
        self.assertIn("tags: [foo, bar]", r.stdout)

    def test_excludes_body_content(self):
        r = run(str(FIXTURES / "with_frontmatter.md"))
        self.assertNotIn("body content", r.stdout)


class TestFmNoFrontmatter(unittest.TestCase):
    def test_exits_zero(self):
        r = run(str(FIXTURES / "no_frontmatter.md"))
        self.assertEqual(r.returncode, 0)

    def test_no_output(self):
        r = run(str(FIXTURES / "no_frontmatter.md"))
        self.assertEqual(r.stdout, "")


class TestFmDotdotDelimiter(unittest.TestCase):
    def test_exits_zero(self):
        r = run(str(FIXTURES / "dotdot_delimiter.md"))
        self.assertEqual(r.returncode, 0)

    def test_includes_frontmatter_fields(self):
        r = run(str(FIXTURES / "dotdot_delimiter.md"))
        self.assertIn("title: Dotdot Delimiter", r.stdout)

    def test_excludes_body_content(self):
        r = run(str(FIXTURES / "dotdot_delimiter.md"))
        self.assertNotIn("Body content", r.stdout)


class TestFmWrongArgs(unittest.TestCase):
    def test_exits_nonzero_with_no_args(self):
        r = run()
        self.assertEqual(r.returncode, 1)

    def test_prints_usage_with_no_args(self):
        r = run()
        self.assertIn("USAGE", r.stdout)

    def test_exits_nonzero_with_too_many_args(self):
        r = run("a.md", "b.md")
        self.assertEqual(r.returncode, 1)


class TestFmFileNotFound(unittest.TestCase):
    def test_exits_nonzero(self):
        r = run("/nonexistent/path/file.md")
        self.assertNotEqual(r.returncode, 0)


if __name__ == "__main__":
    unittest.main()
