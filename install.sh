#!/usr/bin/env bash

# Run on new machine as:
#   bash <(curl -s https://raw.githubusercontent.com/widgetii/.dotfiles/master/install.sh)
# OR
#   wget -q https://raw.githubusercontent.com/widgetii/.dotfiles/master/install.sh -O - | bash

set -e

ALTHOMESPACE="/opt/local"

function detect_OS {
    if [ -f /etc/os-release ]; then
        # freedesktop.org and systemd
        . /etc/os-release
        OS=$NAME
        VER=$VERSION_ID
    elif type lsb_release >/dev/null 2>&1; then
        # linuxbase.org
        OS=$(lsb_release -si)
        VER=$(lsb_release -sr)
    elif [ -f /etc/lsb-release ]; then
        # For some versions of Debian/Ubuntu without lsb_release command
        . /etc/lsb-release
        OS=$DISTRIB_ID
        VER=$DISTRIB_RELEASE
    elif [ -f /etc/debian_version ]; then
        # Older Debian/Ubuntu/etc.
        OS=Debian
        VER=$(cat /etc/debian_version)
    elif [ -f /etc/SuSe-release ]; then
        # Older SuSE/etc.
        ...
    elif [ -f /etc/redhat-release ]; then
        # Older Red Hat, CentOS, etc.
        ...
    else
        # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
        OS=$(uname -s)
        VER=$(uname -r)
    fi
}

function check_home_space {
    FREESZ=$((`stat -f --format="%a*%S" $HOME`))
    # lower than 1Gb
    [[ $FREESZ -lt 1000000000 ]] || {
        [[ -d "$ALTHOMESPACE" ]] || {
            echo "Low free space detected in $HOME and no alternatives"
            exit 1
        }
    }
    # create alternative home directory
    ALT="$ALTHOMESPACE/$USER"
    [[ -d "$ALT" ]] || {
        echo "Creating $ALT..."
        sudo mkdir "$ALT"
        sudo chown $USER:root "$ALT"
        sudo chmod 700 "$ALT"
    }
}

function install_rcup {
	echo "Installing RCM"
	case $OS in
	Ubuntu)
		sudo add-apt-repository -y ppa:martin-frost/thoughtbot-rcm
		sudo apt-get -y update
		sudo apt-get -y install rcm
		;;
	CentOS*)
		;;
	Arch*)
		pikaur -S --noconfirm rcm
		;;
	*)
		;;
	esac
}

detect_OS
[[ ! -z "$SUDO_USER" ]] && USER=$SUDO_USER
echo "Detected OS: $OS, version: $VER, user: $USER"
check_home_space

# Install rcm (https://github.com/thoughtbot/rcm)
command -v rcup >/dev/null || install_rcup
exit

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

