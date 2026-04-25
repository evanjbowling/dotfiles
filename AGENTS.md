A personal dotfiles repo with portable bash utility scripts and PS1 terminal support.

## Running tests

```bash
# Run all unit tests
python3 -m unittest discover test

# Run tests for a single script
python3 -m unittest test.test_ascii
```

Tests live in `test/`, fixtures in `test/fixtures/<scriptname>/`. Tests use Python3 `unittest` + `subprocess` — no external dependencies.

## Docker-based integration testing

The Docker workflow simulates a fresh install on Ubuntu to verify the dotfiles work end-to-end on a clean system:

```bash
./devbin/run    # build image and drop into interactive shell
./devbin/build  # build only
```

`src/docker/entry-point.sh` clones the repo from GitHub into `~/.ejb/dotfiles` inside the container, wires up `.bashrc`, and opens a shell. This means Docker tests hit the **remote** repo, not local changes.

## Architecture of bin/ scripts

All scripts are self-contained and designed to be portable across macOS (BSD tools) and Linux (GNU tools). Key patterns to be aware of:

## Commits

Use [conventional commit](https://www.conventionalcommits.org/) format: `<type>(<scope>): <description>`. Common types: `feat`, `fix`, `refactor`, `test`, `doc`, `chore`. Omit Co-Authored-By and Made-With trailers.

## Adding a new bin/ script

1. Add the script to `bin/` with a `#!/usr/bin/env bash` shebang and no extension.
2. Add tests in `test/test_<scriptname>.py` following the pattern in `test/test_ascii.py`.
3. Add fixtures under `test/fixtures/<scriptname>/` as needed.

