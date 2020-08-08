# Dotfiles

My dotfiles.

Using [dotbot](https://github.com/anishathalye/dotbot) with some
[Dotbot plugins](https://github.com/anishathalye/dotbot/wiki/Plugins)

Additions over vanilla dotbot:

* Customized install script that supports multi-machine profiles and
  auto-discovers and configures dotbot plugins.
* Ability to run ansible to handle more complex configuration steps.

## Installation

```bash
cd ~
git clone --recursive https://github.com/ycanty/dotfiles
```

## Upgrade

```bash
cd ~/dotfiles
git submodule update --remote dotbot plugins/*
git status
# if there are changes:
git add .
git commit -m "Upgraded dotbot and plugins"
```

## Usage

```bash
cd ~/dotfiles
./install --help
./install --profile <profile-name>
./install --config <config-name> --config <another-name> [...]
```

## Design

```
ansible/  # ansible config to run ansible shell step
configs/  # dotfile configurations
dotbot/   # dotbot tool, as a git submodule
plugins/  # dotbot plugins.  Content auto-discovered by install script
profiles/ # configuration profiles.  Lists configs to install
install   # the main install script
```

## TODO

* setup duckdns config (get token using lpass)
* setup .ssh keys (get private key using lpass)
* Setup macos defaults (e.g. https://www.defaults-write.com)

## References

The following provided me the inspiration for this project:

* https://github.com/unixorn/awesome-zsh-plugins
* https://www.viget.com/articles/zsh-config-productivity-plugins-for-mac-oss-default-shell/
* https://www.twilio.com/blog/using-dotfiles-productivity-bootstrap-systems
* https://driesvints.com/blog/getting-started-with-dotfiles/
* https://frkl.io/blog/managing-dotfiles/
* https://www.anishathalye.com/2014/08/03/managing-your-dotfiles/
* https://grantammons.me/2017/11/26/efficiently-managing-dotfiles/
* https://github.com/webpro/awesome-dotfiles
* https://www.atlassian.com/git/tutorials/dotfiles


### Other Tools

https://yadm.io
https://www.gnu.org/software/stow/
https://dotfiles.github.io
https://github.com/technicalpickles/homesick
https://github.com/thoughtbot/rcm
https://starship.rs
https://asdf-vm.com/#/
https://www.defaults-write.com
https://github.com/lastpass/lastpass-cli
