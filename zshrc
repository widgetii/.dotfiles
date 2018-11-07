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
  git
  zsh-autosuggetions
  colored-man-pages
  aws
  docker
  docker-machine
  jira
  jsontools
  npm
  python
  sudo
  systemd
  vagrant
  web-search
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

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
fi

if [[ `uname` == 'Darwin' ]]
then
    source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# local envs
if [[ -s "$HOME/.zshlocal" ]] ; then
    source "$HOME/.zshlocal"
fi

# more colors!
export GTEST_COLOR=yes
alias ip="ip -c"
alias tree="tree -C"
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

# some localizations
# Russian linux man pages
alias rman="LANG=ru_RU.UTF-8 man"
# I want to try vim as man viewer
# https://kgrz.io/faster-vim-better-manpager.html
export MANPAGER="$EDITOR -c 'set ft=man ts=8 nomod nolist nonu noma cursorline' -"

# exports
export PATH="$HOME/.local/bin:$PATH"

# transfer.sh
transfer() { if [ $# -eq 0 ]; then echo -e "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; return 1; fi 
tmpfile=$( mktemp -t transferXXX ); if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; fi; cat $tmpfile; rm -f $tmpfile; } 

# Weather
alias wtr='curl -H "Accept-Language: ru" wttr.in/Москва'

# Multimedia
alias yt="youtube-viewer -fs"

# Network
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"

# Clipboard
# Copy entire file to system clipboard
alias xc="xclip -sel clip < "

# WHAT'S NEXT?
# https://github.com/clvv/fasd
# Try to use in real life
#`````````````` plugins/vi-mode/vi-mode.plugin.zsh

# From https://github.com/zsh-users/zsh-autosuggestions
# My trial of make autosuggestion like autocomplete in Vim

bindkey '^y' autosuggest-execute
bindkey '^q' autosuggest-clear

