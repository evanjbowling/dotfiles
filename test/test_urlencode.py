"""
Tests for bin/urlencode

Encodes or decodes URL strings. Input comes from positional args (joined with
spaces) or stdin. Errors go to stderr. No input with a TTY exits nonzero.
"""

import subprocess
import unittest
from pathlib import Path

REPO_ROOT = Path(__file__).parent.parent
BIN = REPO_ROOT / "bin" / "urlencode"


def run(*args, stdin=None):
    return subprocess.run(
        [str(BIN), *args],
        input=stdin,
        capture_output=True,
        text=True,
    )


class TestUrlencodeEncode(unittest.TestCase):
    def test_encodes_space_as_plus(self):
        r = run("hello world")
        self.assertEqual(r.stdout.strip(), "hello+world")

    def test_encodes_special_chars(self):
        r = run("text,that,works")
        self.assertEqual(r.stdout.strip(), "text%2Cthat%2Cworks")

    def test_encodes_multiple_args_joined(self):
        r = run("hello", "world")
        self.assertEqual(r.stdout.strip(), "hello+world")

    def test_exits_zero(self):
        r = run("hello")
        self.assertEqual(r.returncode, 0)


class TestUrlencodeDecode(unittest.TestCase):
    def test_decodes_percent_encoding(self):
        r = run("-d", "hello%20world")
        self.assertEqual(r.stdout.strip(), "hello world")

    def test_decodes_plus_as_space(self):
        r = run("--decode", "hello+world")
        self.assertEqual(r.stdout.strip(), "hello world")

    def test_decodes_special_chars(self):
        r = run("-d", "text%2Cthat%2Cworks")
        self.assertEqual(r.stdout.strip(), "text,that,works")

    def test_exits_zero(self):
        r = run("-d", "hello%20world")
        self.assertEqual(r.returncode, 0)


class TestUrlencodeStdin(unittest.TestCase):
    def test_encodes_from_stdin(self):
        r = run(stdin="hello world")
        self.assertEqual(r.stdout.strip(), "hello+world")

    def test_decodes_from_stdin(self):
        r = run("-d", stdin="hello+world")
        self.assertEqual(r.stdout.strip(), "hello world")


class TestUrlencodeEmptyInput(unittest.TestCase):
    # The "no input" error path only fires when stdin is a TTY, which
    # subprocess never provides. Empty stdin is treated as an empty string.
    def test_empty_stdin_exits_zero(self):
        r = subprocess.run(
            [str(BIN)],
            input="",
            capture_output=True,
            text=True,
        )
        self.assertEqual(r.returncode, 0)

    def test_empty_stdin_produces_empty_output(self):
        r = subprocess.run(
            [str(BIN)],
            input="",
            capture_output=True,
            text=True,
        )
        self.assertEqual(r.stdout.strip(), "")


class TestUrlencodeUnknownFlag(unittest.TestCase):
    def test_exits_nonzero(self):
        r = run("--invalid")
        self.assertNotEqual(r.returncode, 0)

    def test_error_goes_to_stderr(self):
        r = run("--invalid")
        self.assertGreater(len(r.stderr), 0)


if __name__ == "__main__":
    unittest.main()
