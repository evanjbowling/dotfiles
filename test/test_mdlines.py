"""
Tests for bin/mdlines

The script extracts sentences and list items from a markdown file,
one per line, with markdown formatting stripped and code blocks excluded.
It exits 0 on success, 1 on error.
"""

import subprocess
import unittest
from pathlib import Path

REPO_ROOT = Path(__file__).parent.parent
BIN = REPO_ROOT / "bin" / "mdlines"
FIXTURES = Path(__file__).parent / "fixtures" / "mdlines"


def run(*args):
    return subprocess.run(
        [str(BIN), *args],
        capture_output=True,
        text=True,
    )


def lines(stdout):
    return stdout.strip().splitlines() if stdout.strip() else []


class TestMdlinesProse(unittest.TestCase):
    def setUp(self):
        r = run(str(FIXTURES / "prose.md"))
        self.out = lines(r.stdout)
        self.returncode = r.returncode

    def test_exits_zero(self):
        self.assertEqual(self.returncode, 0)

    def test_splits_sentences(self):
        self.assertEqual(self.out, ["First sentence.", "Second sentence.", "Third sentence."])

    def test_one_sentence_per_line(self):
        self.assertEqual(len(self.out), 3)


class TestMdlinesLists(unittest.TestCase):
    def setUp(self):
        r = run(str(FIXTURES / "lists.md"))
        self.out = lines(r.stdout)

    def test_extracts_list_items(self):
        self.assertIn("Item one.", self.out)
        self.assertIn("Item two.", self.out)

    def test_flattens_nested_items(self):
        self.assertIn("Nested item.", self.out)

    def test_no_list_markers(self):
        for line in self.out:
            self.assertNotRegex(line, r"^[-*+]\s")


class TestMdlinesCodeBlock(unittest.TestCase):
    def setUp(self):
        r = run(str(FIXTURES / "code_block.md"))
        self.out = lines(r.stdout)

    def test_excludes_code_block_content(self):
        self.assertNotIn("def foo():", self.out)
        self.assertNotIn("return 42", self.out)

    def test_includes_prose_around_code(self):
        self.assertIn("Before code.", self.out)
        self.assertIn("After code.", self.out)


class TestMdlinesDuplicates(unittest.TestCase):
    """A sentence in prose and the same text as a list item both appear."""

    def setUp(self):
        r = run(str(FIXTURES / "duplicates.md"))
        self.out = lines(r.stdout)

    def test_sentence_appears_twice(self):
        sentence = "The system handles retries automatically."
        self.assertEqual(self.out.count(sentence), 2)

    def test_sort_uniq_surfaces_duplicate(self):
        """Sorting the output and filtering for duplicates should find the sentence."""
        sorted_lines = sorted(self.out)
        seen = set()
        duplicates = set()
        for line in sorted_lines:
            if line in seen:
                duplicates.add(line)
            seen.add(line)
        self.assertIn("The system handles retries automatically.", duplicates)


class TestMdlinesEmpty(unittest.TestCase):
    def test_exits_zero(self):
        r = run(str(FIXTURES / "empty.md"))
        self.assertEqual(r.returncode, 0)

    def test_no_output(self):
        r = run(str(FIXTURES / "empty.md"))
        self.assertEqual(r.stdout, "")


class TestMdlinesMissingArgument(unittest.TestCase):
    def test_exits_nonzero(self):
        r = run()
        self.assertEqual(r.returncode, 1)

    def test_prints_usage(self):
        r = run()
        self.assertIn("usage", r.stdout)


class TestMdlinesFileNotFound(unittest.TestCase):
    def test_exits_nonzero(self):
        r = run("/nonexistent/path/file.md")
        self.assertEqual(r.returncode, 1)

    def test_prints_error(self):
        r = run("/nonexistent/path/file.md")
        self.assertIn("Error", r.stdout)


if __name__ == "__main__":
    unittest.main()
