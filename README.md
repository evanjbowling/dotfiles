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
./devbin/run.sh
source ~/.bash_ejb # TODO: find way to automate this
```
## Copyright

Copyright (c) Evan Bowling. See [LICENSE](LICENSE).
