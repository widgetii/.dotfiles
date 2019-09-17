#!/usr/bin/env bash

# Run on new machine as:
#   curl -L https://git.io/fjWOf | bash
# OR
#   wget -q https://git.io/fjWOf -O - | bash

# TODO:
# setup OS X using ideas from https://github.com/diimdeep/dotfiles/tree/master/osx/configure
# setup node on Linux using https://github.com/nodesource/distributions

set -e
set -x

ALTHOMESPACE="/opt/local"
# Find last stable version on https://github.com/neovim/neovim/releases/tag/stable
NVIM_AIMG="https://github.com/neovim/neovim/releases/download/stable/nvim.appimage"

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

function check_connectivity {
    case "$(curl -s --max-time 2 -I http://google.com | sed 's/^[^ ]*  *\([0-9]\).*/\1/; 1q')" in
        # HTTP connectivity is up"
        [23]) return 0;;
        # Something goes wrong
        5) echo "The web proxy won't let us through";;
        *) echo "The network is down or very slow";;
    esac
    return 1
}

function clean_up {
    if [[ ! -z "$CLEANCMD" ]]; then
        echo "Perform cleanup:"
        echo $CLEANCMD
        bash -c "$CLEANCMD"
        CLEANCMD=""
    fi
}

function setup_temp_proxies {
    case $OS in
    Ubuntu* | Debian*)
        echo "Acquire::http::Proxy \"http://$http_proxy\";" | sudo tee /etc/apt/apt.conf.d/proxy
        CLEANCMD="sudo rm /etc/apt/apt.conf.d/proxy"
        trap clean_up EXIT SIGHUP SIGINT SIGTERM
        ;;
    CentOS*)
        grep -q "^proxy" /etc/yum.conf || \
            echo "proxy=http://$http_proxy" | sudo tee -a /etc/yum.conf
        CLEANCMD="grep -q '^proxy' /etc/yum.conf && sudo sed -i '/^proxy/d' /etc/yum.conf"
        trap clean_up EXIT SIGHUP SIGINT SIGTERM
        ;;
    esac
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
    Ubuntu*)
        sudo add-apt-repository -y ppa:martin-frost/thoughtbot-rcm
        sudo apt-get -y update
        sudo apt-get -y install rcm
        ;;
    Debian*)
        wget -qO - https://apt.thoughtbot.com/thoughtbot.gpg.key | sudo apt-key add -
        echo "deb https://apt.thoughtbot.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/thoughtbot.list
        # fix for "The method driver /usr/lib/apt/methods/https could not be found."
        sudo apt install -y apt-transport-https
        sudo apt-get -y update
        sudo apt-get install rcm
        ;;
    Arch*)
        pikaur -S --noconfirm rcm
        ;;
    Darwin*)
        brew tap thoughtbot/formulae
        brew install rcm
        ;;
    CentOS*)
        [ "$VER" == "7" ] && {
            curl https://download.opensuse.org/repositories/utilities/RHEL_7/utilities.repo | sudo tee /etc/yum.repos.d/utilities.repo
            sudo yum install -y rcm
            # remove repo after install
            sudo rm /etc/yum.repos.d/utilities.repo
        }
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
    Ubuntu* | Debian*)
        sudo apt install -y git
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
    Ubuntu* | Debian*)
        sudo apt install -y zsh #zsh-syntax-highlighting
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

function install_neovim_as_appimage {
    LCL="$HOME/.local"
    mkdir -p $LCL
    cd $LCL

    APPIMG="nvim.appimage"
    curl -L $NVIM_AIMG > $APPIMG
    chmod u+x $APPIMG
    ./$APPIMG --appimage-extract
    mv squashfs-root/* $LCL
    rm -rf ./squashfs-root
    rm -rf $APPIMG
    cd $LCL/bin
    ln -sv ../usr/bin/nvim nvim
    sudo ln -sv $LCL/usr/bin/nvim /usr/bin/nvim
}

function install_neovim {
    echo "Installing Neovim"
    case $OS in
    Ubuntu*)
        sudo apt-get install -y software-properties-common
        sudo add-apt-repository -y ppa:neovim-ppa/stable
        sudo apt-get -y update
        sudo apt-get -y install neovim
        sudo apt-get -y install python-dev python-pip python3-dev python3-pip
        ONLY_ALTUPD=1
        ;;
    Debian*)
        # for Debian only
        [ -z "$ONLY_ALTUPD" ] && {
            install_neovim_as_appimage
        }
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
        install_neovim_as_appimage
        ;;
    *)
        ;;
    esac
}

function install_pip3 {
    echo "Installing pip3"
    case $OS in
    Ubuntu* | Debian*)
        sudo apt-get -y install python3-pip
        ;;
    Arch*)
        ;;
    Darwin*)
        ;;
    CentOS*)
        [ "$VER" == "7" ] && {
            sudo yum install -y https://centos7.iuscommunity.org/ius-release.rpm
            sudo yum install -y python36u-pip
            sudo ln -sv /usr/bin/pip3.6 /usr/local/bin/pip3
            sudo ln -sv /usr/bin/python3.6 /usr/local/bin/python3
        }
        ;;
    *)
        ;;
    esac
}

function install_zsh_autojump {
    echo "Installing autojump"
    case $OS in
    Ubuntu* | Debian*)
        sudo apt install -y autojump
        ;;
    Arch*)
        # ?
        ;;
    Darwin*)
        brew install autojump
        ;;
    CentOS*)
        sudo yum install -y autojump-zsh
        ;;
    *)
        ;;
    esac
}

function install_golang {
    echo "Installing Go"
    case $OS in
    Ubuntu* | Debian*)
        sudo apt install -y golang
        ;;
    Arch*)
        # ?
        ;;
    Darwin*)
        ;;
    CentOS*)
        ;;
    *)
        ;;
    esac
}

function install_ccat {
    echo "Installing Ccat"
    case $OS in
    Arch*)
        pikaur -S ccat-git
        ;;
    Darwin*)
        brew install ccat
        ;;
    *)
        LBIN="$HOME/.local/bin"
        mkdir -p $LBIN
        curl -L --output /tmp/ccat.tgz \
            https://github.com/jingweno/ccat/releases/download/v1.1.0/linux-amd64-1.1.0.tar.gz
        tar xvf /tmp/ccat.tgz -C $LBIN --strip-components 1 linux-amd64-1.1.0/ccat
        ;;
    esac
}

function fix_term_for_root {
    ROOTDIR="/root"
    [[ "$OS" =~ Darwin ]] && ROOTDIR="/var/root"
    sudo cp -rv $HOME/.terminfo $ROOTDIR
}

if [[ "$USER" == "root" ]]; then
    echo "Don't run the script from root!"
    exit 2
fi

detect_OS
[[ ! -z "$SUDO_USER" ]] && USER=$SUDO_USER
echo "Detected OS: $OS, version: $VER, user: $USER"

[[ "$OS" == "Darwin" ]] || check_home_space

check_connectivity || {
    echo "launch goproxy on local machine:"
    echo "  proxy http --local-type=tcp --local=:33080"
    echo "and make a connection to remote one with forwarding:"
    echo "  ssh -R 8080:localhost:33080 <host>"
    echo "  export http_proxy=127.1:8080 && export https_proxy=127.1:8080"
    exit 3
}

[ -z "$https_proxy" ] || setup_temp_proxies

# Check zsh and install it
command -v zsh >/dev/null || {
    install_zsh
    BASH_PROFILE="/home/$USER/.bash_profile"
    if [[ ! -z "$ALT" ]]; then
        echo "export HOME=$ALT" >> $BASH_PROFILE
        echo "cd $ALT" >> $BASH_PROFILE
    fi
    echo "export SHELL=\`which zsh\`" >> $BASH_PROFILE
    echo "[ -z \"\$ZSH_VERSION\" ] && exec \"\$SHELL\" -l" >> $BASH_PROFILE
}

# Install rcm (https://github.com/thoughtbot/rcm)
command -v rcup >/dev/null || install_rcup

# Install git
command -v git >/dev/null || install_git

# Install small utilities
command -v ccat >/dev/null || install_ccat

# Clone dotfiles
if [[ ! -d "$HOME/.dotfiles" ]]; then
    cd $HOME
    git clone https://github.com/widgetii/.dotfiles
    # workaround for avoid error with Code's dir
    mkdir -p "$HOME/.config/Code - OSS/User/"
    rcup
    fix_term_for_root
else
    cd $HOME/.dotfiles
    echo "Updating .dotfiles"
    git pull
    rcup
fi

# Install oh-my-zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
    install_zsh_autojump
fi

# Install powerlevel9k theme
if [[ ! -d "$HOME/.oh-my-zsh/themes/powerlevel9k" ]]; then
    git clone https://github.com/bhilburn/powerlevel9k $HOME/.oh-my-zsh/themes/powerlevel9k
fi

# Install neovim (https://github.com/neovim/neovim/wiki/Installing-Neovim)
command -v nvim -version >/dev/null || {
    install_neovim
    command -v pip3 >/dev/null || install_pip3
    pip3 install pynvim --user
    #sh -c 'nvim +PlugInstall +qall </dev/null'
    echo "run:"
    echo "nvim +PlugInstall +qall"
}

clean_up

# close stdin after dup'ing it to FD 6
#exec 6<&0
# open /dev/tty as stdin
#exec 0</dev/tty

#[[ "$SHELL" =~ (bash) ]] && exec zsh

