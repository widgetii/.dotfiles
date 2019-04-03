#!/usr/bin/env bash -e

# Ubuntu only

# Install rcm (https://github.com/thoughtbot/rcm)

# Zsh
Check zsh and install it
sudo chsh -s $(which zsh) $USER
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
git clone https://github.com/bhilburn/powerlevel9k $HOME/.oh-my-zsh/themes/powerlevel9k

# Debian

wget -qO - https://apt.thoughtbot.com/thoughtbot.gpg.key | sudo apt-key add -
echo "deb https://apt.thoughtbot.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/thoughtbot.list
sudo apt-get update
sudo apt-get install rcm

# Install neovim (https://github.com/neovim/neovim/wiki/Installing-Neovim)

sudo add-apt-repository ppa:neovim-ppa/stable -y
sudo apt-get update # realy needed?
sudo apt-get install neovim

sudo apt-get install python-dev python-pip python3-dev python3-pip
pip3 install pynvim

# Use as default

sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
sudo update-alternatives --set vi /usr/bin/nvim
sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
sudo update-alternatives --set vim /usr/bin/nvim
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
sudo update-alternatives --set editor /usr/bin/nvim

