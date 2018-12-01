#!/usr/bin/env bash

# Commands based on sqlite3 CLI
# see https://www.sqlite.org/cli.html

# 0. Open db
sqlite3 test.db

# 0a. Open db from sqlite prompt
sqlite3
sqlite> .open test.db

# 1. List database info from sqlite prompt
sqlite> .dbinfo

# 2. List tables from sqlite prompt
sqlite> .tables

# 3. List help from sqlite prompt
sqlite> .help

# 4. Run system command from sqlite prompt
sqlite> .system ls -aoh
