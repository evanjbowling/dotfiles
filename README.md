# dotfiles

## Details

This repo installs

__Files__:


* `~/.ejb/dotfiles` - a clone of this repo

## Install

```bash
# create dir and clone repo
if [ ! -d "$HOME/.ejb/dotfiles" ]; then
  mkdir $HOME/.ejb
  git clone https://github.com/evanjbowling/dotfiles.git $HOME/.ejb/dotfiles
  echo "Created $HOME/.ejb/dotfiles"
fi

# run the install script, then open a new terminal for the changes to take effect
$HOME/.ejb/dotfiles/install.sh
```

`install.sh` sources `.bash_ejb` from your shell profile, copies/renders the
tracked dotfiles (`.gitconfig`, `.vimrc`, `.emacs.d`) into `$HOME`, and runs the
`setup/` scripts. It will prompt for your name/email to render `.gitconfig`, and
won't overwrite a destination file that already differs from the repo's version.

Run `devbin/diff-installed` at any time to see how the files in `$HOME` compare
to what's in the repo.

## Setup

macOS/Linux machine bootstrap tasks live in `setup/` and run automatically at
the end of `install.sh` (skip with `install.sh --skip-setup`), or individually:

```bash
setup/ssh         # ~/.ssh dir, SSH keygen prompt, ~/.ssh/config github.com entry
setup/hushlogin   # macOS only: silence the login banner
```

## Update

```bash
cd ~/.ejb/dotfiles
git pull > /dev/null 2>&1
git reset --hard origin/master > /dev/null 2>&1
```

## Development

### Test

```bash
./devbin/run                      # tests master
./devbin/run some-branch-name     # tests a pushed branch/ref instead
```

### Snippets

__~/.ssh/config__ (`setup/ssh` writes the `github.com` block automatically;
this is just an example for adding other hosts)

```
Host dev
    HostName dev.example.com
    Port 22000
    User louie
```

## Copyright

Copyright (c) Evan Bowling. See [LICENSE](LICENSE).
