"""
Tests for bin/ascii

The script exits 0 when a file contains only ASCII characters,
exits 1 when non-ASCII characters are found (and prints the offending lines),
and exits 1 with a usage/error message when arguments are missing or invalid.

The -q / --quiet flag suppresses all output while preserving exit codes.
"""

import subprocess
import unittest
from pathlib import Path

REPO_ROOT = Path(__file__).parent.parent
BIN = REPO_ROOT / "bin" / "ascii"
FIXTURES = Path(__file__).parent / "fixtures" / "ascii"


def run(*args):
    return subprocess.run(
        [str(BIN), *args],
        capture_output=True,
        text=True,
    )


class TestAsciiCleanFile(unittest.TestCase):
    def test_exits_zero_for_clean_file(self):
        r = run(str(FIXTURES / "clean.txt"))
        self.assertEqual(r.returncode, 0)

    def test_no_output_for_clean_file(self):
        r = run(str(FIXTURES / "clean.txt"))
        self.assertEqual(r.stdout, "")
        self.assertEqual(r.stderr, "")


class TestAsciiNonAsciiFile(unittest.TestCase):
    def test_exits_nonzero_for_non_ascii_file(self):
        r = run(str(FIXTURES / "non_ascii.txt"))
        self.assertEqual(r.returncode, 1)

    def test_prints_offending_line(self):
        r = run(str(FIXTURES / "non_ascii.txt"))
        # The script prints the line(s) containing non-ASCII characters
        self.assertGreater(len(r.stdout), 0)


class TestAsciiEmptyFile(unittest.TestCase):
    def test_exits_zero_for_empty_file(self):
        r = run(str(FIXTURES / "empty.txt"))
        self.assertEqual(r.returncode, 0)


class TestAsciiMissingArgument(unittest.TestCase):
    def test_exits_nonzero_with_no_args(self):
        r = run()
        self.assertEqual(r.returncode, 1)

    def test_prints_usage_with_no_args(self):
        r = run()
        self.assertIn("Usage", r.stdout)


class TestAsciiFileNotFound(unittest.TestCase):
    def test_exits_nonzero_for_missing_file(self):
        r = run("/nonexistent/path/file.txt")
        self.assertEqual(r.returncode, 1)

    def test_prints_error_for_missing_file(self):
        r = run("/nonexistent/path/file.txt")
        self.assertIn("Error", r.stdout)


class TestAsciiQuietFlag(unittest.TestCase):
    def test_quiet_suppresses_output_on_non_ascii(self):
        r = run("-q", str(FIXTURES / "non_ascii.txt"))
        self.assertEqual(r.returncode, 1)
        self.assertEqual(r.stdout, "")

    def test_quiet_suppresses_usage_message(self):
        r = run("--quiet")
        self.assertEqual(r.returncode, 1)
        self.assertEqual(r.stdout, "")

    def test_quiet_suppresses_error_for_missing_file(self):
        r = run("--quiet", "/nonexistent/path/file.txt")
        self.assertEqual(r.returncode, 1)
        self.assertEqual(r.stdout, "")

    def test_quiet_clean_file_still_exits_zero(self):
        r = run("-q", str(FIXTURES / "clean.txt"))
        self.assertEqual(r.returncode, 0)


if __name__ == "__main__":
    unittest.main()
