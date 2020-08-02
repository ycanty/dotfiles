# Dotfiles

Using [dotbot](https://github.com/anishathalye/dotbot) with some
[Dotbot plugins](https://github.com/anishathalye/dotbot/wiki/Plugins)

## Installation

```bash
cd ~
git clone --recursive https://github.com/ycanty/dotfiles
```

## Upgrade

```bash
cd ~/dotfiles
git submodule update --remote dotbot
git submodule update --remote plugins/*
git status
# if there are changes:
git add .
git commit -m "Upgraded dotbot and plugins"
```

## Usage

```bash
cd ~/dotfiles
./install # lists available profiles
./install <profile-name>
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

* Install vscode plugins
* Install intellij plugins (write a dotbot plugin?)
* setup duckdns config (get token using lpass)
* setup .ssh keys (get private key using lpass)
* setup starship
* reorganize bin/ scripts

## References

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
