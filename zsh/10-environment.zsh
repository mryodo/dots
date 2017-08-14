#!/usr/bin/zsh

pathadd "$HOME/.bin"
pathadd "$HOME/.cabal/bin"
pathadd "$HOME/.cargo/bin"
pathadd "$HOME/.go/bin"
pathadd "/bin"
pathadd "/sbin"
pathadd "/usr/bin"
pathadd "/usr/local/bin"
pathadd "/usr/local/sbin"
pathadd "/usr/sbin"

export EDITOR="/usr/bin/nvim"
export VISUAL="/usr/bin/nvim"
export PAGER="/usr/bin/less"
export DIFF="/usr/bin/colordiff"
export BROWSER="/usr/bin/firefox"

export GOPATH="$HOME/.go"

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=100000
export SAVEHIST=100000

export KEYTIMEOUT=1

export GCC_COLORS=1
