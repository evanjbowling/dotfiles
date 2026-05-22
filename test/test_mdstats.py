"""
Tests for bin/mdstats

The script computes statistics for a markdown file and prints one
key: value pair per line. It exits 0 on success, 1 on error.
"""

import subprocess
import unittest
from pathlib import Path

REPO_ROOT = Path(__file__).parent.parent
BIN = REPO_ROOT / "bin" / "mdstats"
FIXTURES = Path(__file__).parent / "fixtures" / "mdstats"


def run(*args):
    return subprocess.run(
        [str(BIN), *args],
        capture_output=True,
        text=True,
    )


def parse_output(stdout):
    result = {}
    for line in stdout.strip().splitlines():
        key, _, value = line.partition(": ")
        result[key] = int(value)
    return result


class TestMdstatsSimple(unittest.TestCase):
    def setUp(self):
        r = run(str(FIXTURES / "simple.md"))
        self.stats = parse_output(r.stdout)
        self.returncode = r.returncode

    def test_exits_zero(self):
        self.assertEqual(self.returncode, 0)

    def test_word_count(self):
        self.assertEqual(self.stats["words"], 14)

    def test_sentence_count(self):
        self.assertEqual(self.stats["sentences"], 6)

    def test_paragraph_count(self):
        self.assertEqual(self.stats["paragraphs"], 3)

    def test_list_item_count(self):
        self.assertEqual(self.stats["list_items"], 2)

    def test_code_block_lines(self):
        self.assertEqual(self.stats["code_block_lines"], 3)

    def test_image_count(self):
        self.assertEqual(self.stats["images"], 1)

    def test_prose_reading_time(self):
        self.assertEqual(self.stats["prose_reading_time_sec"], 4)

    def test_code_reading_time(self):
        self.assertEqual(self.stats["code_reading_time_sec"], 6)

    def test_image_reading_time(self):
        self.assertEqual(self.stats["image_reading_time_sec"], 12)

    def test_total_reading_time(self):
        self.assertEqual(self.stats["total_reading_time_sec"], 22)


class TestMdstatsEmpty(unittest.TestCase):
    def setUp(self):
        r = run(str(FIXTURES / "empty.md"))
        self.stats = parse_output(r.stdout)
        self.returncode = r.returncode

    def test_exits_zero(self):
        self.assertEqual(self.returncode, 0)

    def test_all_zeros(self):
        for key, value in self.stats.items():
            self.assertEqual(value, 0, f"{key} should be 0 for empty file")


class TestMdstatsMissingArgument(unittest.TestCase):
    def test_exits_nonzero(self):
        r = run()
        self.assertEqual(r.returncode, 1)

    def test_prints_usage(self):
        r = run()
        self.assertIn("usage", r.stdout)


class TestMdstatsFileNotFound(unittest.TestCase):
    def test_exits_nonzero(self):
        r = run("/nonexistent/path/file.md")
        self.assertEqual(r.returncode, 1)

    def test_prints_error(self):
        r = run("/nonexistent/path/file.md")
        self.assertIn("Error", r.stdout)


if __name__ == "__main__":
    unittest.main()
