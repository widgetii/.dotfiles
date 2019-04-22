#!/usr/bin/env bash

# Run on new machine as:
#   curl -L https://raw.githubusercontent.com/widgetii/.dotfiles/master/install.sh | bash
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
    # check if home partition is lower than 1Gb
    if [[ "$FREESZ" -lt "1000000000" ]]; then
        if [[ ! -d "$ALTHOMESPACE" ]]; then
            echo "Low free space detected in $HOME and no alternatives"
            exit 1
        fi
        # create alternative home directory
        ALT="$ALTHOMESPACE/$USER"
        if [[ ! -d "$ALT" ]]; then
            echo "Creating $ALT..."
            sudo mkdir "$ALT"
            sudo chown $USER:root "$ALT"
            sudo chmod 700 "$ALT"
        fi
        export HOME="$ALT"
        cd $HOME
    fi
}

function install_rcup {
	echo "Installing RCM"
	case $OS in
	Ubuntu)
		sudo add-apt-repository -y ppa:martin-frost/thoughtbot-rcm
		sudo apt-get -y update
		sudo apt-get -y install rcm
		;;
	Arch*)
		pikaur -S --noconfirm rcm
		;;
    Darwin*)
        brew tap thoughtbot/formulae
        brew install rcm
        ;;
	*)
        TMPDIR=`mktemp -d -p "${XDG_RUNTIME_DIR}"`
        cd "$TMPDIR"
        curl -LO https://thoughtbot.github.io/rcm/dist/rcm-1.3.3.tar.gz &&
            tar -xvf rcm-1.3.3.tar.gz &&
            cd rcm-1.3.3 &&
            ./configure &&
            make &&
            sudo make install
        rm -rf "$TMPDIR"
		;;
	esac
}

function install_git {
    echo "Installing Git"
    case $OS in
    Ubuntu)
        ;;
    Arch*)
        ;;
    Darwin*)
        ;;
    CentOS*)
        sudo yum -y install git
        ;;
    *)
        ;;
    esac
}

function install_zsh {
    echo "Installing Zsh"
    case $OS in
    Ubuntu)
        apt install -y zsh
        ;;
    Arch*)
        sudo pacman -S zsh
        ;;
    Darwin*)
        brew install zsh zsh-completions
        ;;
    CentOS*)
        sudo yum -y install zsh
        ;;
    *)
        ;;
    esac
}

function install_neovim {
    echo "Installing Neovim"
    case $OS in
    Ubuntu)
        sudo apt-get install -y software-properties-common
        sudo add-apt-repository -y ppa:neovim-ppa/stable
        sudo apt-get -y update
        sudo apt-get -y install neovim
        sudo apt-get -y install python-dev python-pip python3-dev python3-pip

        # Use as default
        sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
        sudo update-alternatives --set vi /usr/bin/nvim
        sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
        sudo update-alternatives --set vim /usr/bin/nvim
        sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
        sudo update-alternatives --set editor /usr/bin/nvim
        ;;
    Arch*)
        sudo pacman -S neovim python-neovim
        ;;
    Darwin*)
        brew install neovim
        ;;
    CentOS*)
        ;;
    *)
        ;;
    esac
}

if [[ "$USER" == "root" ]]; then
    echo "Don't run the script from root!"
    exit 2
fi

detect_OS
[[ ! -z "$SUDO_USER" ]] && USER=$SUDO_USER
echo "Detected OS: $OS, version: $VER, user: $USER"

[[ "$OS" == "Darwin" ]] || check_home_space

# Install rcm (https://github.com/thoughtbot/rcm)
command -v rcup >/dev/null || install_rcup

# Install git
command -v git >/dev/null || install_git

# Clone dotfiles
if [[ ! -d "$HOME/.dotfiles" ]]; then
    cd $HOME
    git clone https://github.com/widgetii/.dotfiles
else
    cd $HOME/.dotfiles
    echo "Updating .dotfiles"
    git pull
fi
rcup

# Check zsh and install it
command -v zsh >/dev/null || {
    install_zsh
    BASH_PROFILE="/home/$USER/.bash_profile"
    if [[ ! -z "$ALT" ]]; then
        echo "export HOME=$ALT" > $BASH_PROFILE
        echo "cd $ALT" >> $BASH_PROFILE
    fi
    echo "export SHELL=\`which zsh\`" >> $BASH_PROFILE
    echo "[ -z \"\$ZSH_VERSION\" ] && exec \"\$SHELL\" -l" >> $BASH_PROFILE
}

# Install oh-my-zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
fi

# Install powerlevel9k theme
if [[ ! -d "$HOME/.oh-my-zsh/themes/powerlevel9k" ]]; then
    git clone https://github.com/bhilburn/powerlevel9k $HOME/.oh-my-zsh/themes/powerlevel9k
fi

# Install neovim (https://github.com/neovim/neovim/wiki/Installing-Neovim)
command -v nvim -version >/dev/null || {
    install_neovim
    pip3 install pynvim
}

