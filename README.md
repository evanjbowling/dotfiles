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

# add the following to .bashrc or equivalent
echo 'if [ -f "$HOME/.ejb/dotfiles/.bash_ejb" ]; then' >> ~/.bashrc
echo '  . "$HOME/.ejb/dotfiles/.bash_ejb"' >> ~/.bashrc
echo 'fi' >> ~/.bashrc
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
./devbin/run
```

### Snippets

__~/.ssh/config__

```
# Example for other systems
#Host dev
#    HostName dev.example.com
#    Port 22000
#    User louie

Host github.com
    IdentityFile ~/.ssh/id_rsa
```

## Copyright

Copyright (c) Evan Bowling. See [LICENSE](LICENSE).
