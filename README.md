# dotfiles

## Details

This repo installs an opinionated set of dotfiles/scripts/etc.

__Files__:


* `~/tools` - directory where new sw is to be installed
* `~/.ejb/dotfiles` - a clone of this repo
* `~/.bash_ejb` - script where aliases are defined
* `~/.bashrc` - code to source `~/.bash_ejb`

__Environment Variables__:

* `TOOLS_HOME` - path to where tools will be installed
* `JAVA_HOME` - currently assumes this will be `${TOOLS_HOME}/jdk`
* `PATH` - updated with directories above

## Usage

### Quick Install

```
curl https://raw.githubusercontent.com/evanjbowling/dotfiles/master/installer > installer && chmod +x installer && ./installer && rm ./installer && bash
```

## Dev

### Test

The current test method builds a new ubuntu docker image and runs the quick install script within it.

```
./devbin/run && source ~/.bash_ejb # TODO: find way to automate the source call in the docker image
```

## Goals
### In Scope
* __easy access__ - aliases/code snippets I find useful
* __reuse__ - configs for random systems (ie. even those that aren't considered production systems)
* __learning__ - understand a bit more about production-grade system config tools like Ansible
* __modular__ - (not realized yet)

## Out of Scope
* provide as many features as Ansible
* Windows/cygwin

## Copyright

Copyright (c) Evan Bowling. See [LICENSE](LICENSE).
