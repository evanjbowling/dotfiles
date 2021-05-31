# dotfiles

## Details

This repo installs

__Files__:


* `~/.ejb/dotfiles` - a clone of this repo

## Install

```bash
# create dir and clone repo
mkdir ~/.ejb
git clone https://github.com/evanjbowling/dotfiles.git ~/.ejb/dotfiles

# add the following to .bashrc or equivalent
echo 'if [ -f "$HOME/.ejb/dotfiles/.bash_ejb" ]; then' >> ~/.bashrc
echo '  . "$HOME/.ejb/dotfiles/.bash_ejb"' >> ~/.bashrc
echo 'fi' >> ~/.bashrc
```

## Development

### Test

```bash
./devbin/run
```

## Copyright

Copyright (c) Evan Bowling. See [LICENSE](LICENSE).
