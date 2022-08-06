# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel9k/powerlevel9k"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
#HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="dd.mm.yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  autojump
  aws
  colored-man-pages
  docker
  docker-machine
  git
  jira
  jsontools
  kubectl
  npm
  python
  safe-paste
  sudo
  systemd
  vagrant
  vi-mode
  web-search
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

if [[ `uname` == 'Linux' ]]
then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    [[ -d /opt/google-cloud-sdk ]] && {
        source /opt/google-cloud-sdk/path.zsh.inc
        source /opt/google-cloud-sdk/completion.zsh.inc
    }

    export LIBVIRT_DEFAULT_URI=qemu:///system
    export VAGRANT_DEFAULT_PROVIDER=libvirt

    # one ssh-agent at a time
    if ! pgrep -u "$USER" ssh-agent > /dev/null; then
        ssh-agent > ~/.ssh-agent-thing
    fi
    if [[ ! "$SSH_AUTH_SOCK" ]]; then
        eval "$(<~/.ssh-agent-thing)"
        ssh-add
        ssh-add .ssh/pg-20201006
        ssh-add .ssh/dev-20201008
    fi
fi

if [[ `uname` == 'Darwin' ]]
then
    source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc
    source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc

    alias xtime="gtime -f='%Uu %Ss %er %MkB %C'"

    alias j8="export JAVA_HOME=`/usr/libexec/java_home -v 1.8`; java -version"
    #alias j9="export JAVA_HOME=`/usr/libexec/java_home -v 9`; java -version"
    export PATH="/usr/local/opt/openjdk@11/bin:$PATH"
fi

# local envs
if [[ -s "$HOME/.zshlocal" ]] ; then
    source "$HOME/.zshlocal"
fi

# more colors!
export GTEST_COLOR=yes
alias ip="ip -c"
alias tree="tree -C"
alias rcat="/bin/cat"
alias cat="ccat"
#alias colors='for code in {0..255}; do echo -e "\e[38;05;${code}m $code: test"; done'

# more settings for theme
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_RPROMPT_ON_NEWLINE=true

POWERLEVEL9K_PROMPT_ADD_NEWLINE=true


# shell aliases
alias reload="source ~/.zshrc"

# my favourite text editor
export EDITOR="nvim"
export VISUAL="$EDITOR"
alias vim="$EDITOR"
alias vi="$EDITOR"
alias v="$EDITOR ."
# open file for edit in NeoVim in top window
alias e='f() { nvr --remote-send "<esc><C-w>e:e $(pwd)/$1<cr>" };f'
alias icat="kitty +kitten icat"
# open file(s) with fzf+vim
alias vf='vim $(fzf)'
alias gd='git difftool --no-symlinks --dir-diff'

# TODO
# good source to work out for git, tmux, docker commands
# https://github.com/liuchengxu/dotfiles/blob/master/bashrc

# some localizations
# Russian linux man pages
alias rman="LANG=ru_RU.UTF-8 man"
# I want to try vim as man viewer
# https://kgrz.io/faster-vim-better-manpager.html
export MANPAGER="$EDITOR -c 'set ft=man ts=8 nomod nolist nonu noma cursorline' -"

# Golang
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"

# NPM global install for current user
export npm_config_prefix="$HOME/.node_modules"

# exports
export PATH="$HOME/.local/bin:$GOBIN:$HOME/.node_modules/bin:$HOME/.kube/plugins/jordanwilson230:$PATH"

# https://0x0.st
transfer() { if [ $# -eq 0 ]; then echo -e "No arguments specified. Usage:\ntransfer filename"; return 1; fi; curl --progress-bar -F"file=@$1" https://0x0.st; }

# Weather
alias wtr='curl -H "Accept-Language: ru" wttr.in/Москва'

# Multimedia
alias yt="youtube-viewer -fs"

# Network
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"

# Clipboard
# Copy entire file to system clipboard
alias xc="xclip -sel clip < "

# Sticky SSH
sssh() {
    while true; do command ssh -q "$@"; [ $? -eq 0 ] && break || sleep 0.5; done
}

alias d8="rlwrap ~/git/v8/v8/out.gn/x64.release/d8 --experimental-wasm-threads"
alias jfr="~/git/jenkinsfile-runner/app/target/appassembler/bin/jenkinsfile-runner"

# Colemak vi-mode
bindkey -M vicmd 's' vi-insert
bindkey -M vicmd 'n' down-line-or-history
bindkey -M vicmd 'e' up-line-or-history
bindkey -M vicmd 'i' vi-forward-char
bindkey -M vicmd '^L' vi-join
# same as on bash
bindkey -M vicmd '^X^e' edit-command-line
bindkey '^X^e' edit-command-line
bindkey '^[f' forward-word
bindkey '^[b' backward-word
bindkey "^[." insert-last-word
bindkey "^B" backward-char
bindkey "^F" forward-char

function zle-line-init zle-keymap-select {
VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]% %{$reset_color%}"
RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $RPROMPT_PREFIX%f%b%k$(build_right_prompt)%{$reset_color%}$RPROMPT_SUFFIX $EPS1"
    zle reset-prompt
}

# WHAT'S NEXT?
# https://github.com/clvv/fasd
# Try to use in real life

# From https://github.com/zsh-users/zsh-autosuggestions
# My trial of make autosuggestion like autocomplete in Vim

bindkey '^y' autosuggest-execute
bindkey -M vicmd '^y' autosuggest-execute
# ^e as in Vim conflicts with Emacs to end of line shortcut
bindkey '^q' autosuggest-clear
# fill the line (make autocompletion but don't execute it)
bindkey '^f' autosuggest-accept

# Stash for Zsh
# you can cancel any ongoing command that you might be typing by hitting <CTRL>q
# perform another command and then come back just to where you left off
bindkey '^`' push-line-or-edit

# https://raw.githubusercontent.com/nachoparker/tab_list_files_zsh_widget/master/tab_list_files_zsh.sh
# List files in zsh with <TAB>
# In the middle of the command line:
#   (command being typed)<TAB>(resume typing)
# At the beginning of the command line:
#   <SPACE><TAB>
#   <SPACE><SPACE><TAB>
# Notes:
#   This does not affect other completions
#   If you want 'cd ' or './' to be prepended, write in your .zshrc 'export TAB_LIST_FILES_PREFIX'
function tab_list_files
{
  if [[ $#BUFFER == 0 ]]; then
    BUFFER="ls "
    CURSOR=3
    zle list-choices
    zle backward-kill-word
  elif [[ $BUFFER =~ ^[[:space:]][[:space:]].*$ ]]; then
    BUFFER="./"
    CURSOR=2
    # TODO: disable directories
    zle list-choices
    [ -z ${TAB_LIST_FILES_PREFIX+x} ] && BUFFER="  " CURSOR=2
  elif [[ $BUFFER =~ ^[[:space:]]*$ ]]; then
    BUFFER="cd "
    CURSOR=3
    zle list-choices
    [ -z ${TAB_LIST_FILES_PREFIX+x} ] && BUFFER=" " CURSOR=1
  else
    BUFFER_=$BUFFER
    CURSOR_=$CURSOR
    zle expand-or-complete || zle expand-or-complete || {
      BUFFER="ls "
      CURSOR=3
      zle list-choices
      BUFFER=$BUFFER_
      CURSOR=$CURSOR_
    }
  fi
}
zle -N tab_list_files
bindkey '^I' tab_list_files

# uncomment the following line to prefix 'cd ' and './'
# when listing dirs and executables respectively
export TAB_LIST_FILES_PREFIX

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
