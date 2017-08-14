#!/usr/bin/zsh

alias cp='/bin/cp --verbose'
alias mv='/bin/mv --verbose'
alias rm='/bin/rm --verbose --interactive=once'
alias mkdir='/bin/mkdir --verbose --parents'
alias rmdir='/bin/rmdir --verbose --parents'

alias ls='/bin/ls --group-directories-first --time-style=+"%d.%m.%y %H:%M" --color=auto --indicator-style=classify'
alias ll='/bin/ls --group-directories-first --time-style=+"%d.%m.%y %H:%M" --color=auto --indicator-style=classify -lh'
alias la='/bin/ls --group-directories-first --time-style=+"%d.%m.%y %H:%M" --color=auto --indicator-style=classify -lha'
alias lg='/bin/ls --group-directories-first --time-style=+"%d.%m.%y %H:%M" --color=auto --indicator-style=classify -lha | grep'

alias grep='/bin/grep -i --color=auto'
alias fgrep='/bin/fgrep -i --color=auto'
alias egrep='/bin/egrep -i --color=auto'

alias r='/usr/bin/ranger'

alias dfh='/bin/df --human-readable --total'

alias free='/usr/bin/free --human --mega'

alias t='/usr/bin/tmux'

alias g='/usr/bin/git'

alias nv='/usr/bin/nvim'

alias e='/usr/bin/emacs --no-window-system'
alias ec='/usr/bin/emacsclient --no-window-system'

alias weather='/usr/bin/curl wttr.in/Moscow'

alias gtypist='/usr/bin/gtypist --personal-best --max-error=100 --term-cursor --quiet --word-processor --show-errors --always-sure --scoring=wpm'

alias scrot='/usr/bin/scrot -q 80'

alias rt='/usr/bin/rtorrent -o http_capath=/etc/ssl/certs'

alias td='/usr/bin/transmission-daemon'
alias tr='/usr/bin/transmission-remote'
alias trc='/usr/bin/transmission-remote-cli'

alias sx='/usr/bin/startx -- vt1'

alias mpw='${HOME}/git/mpw-cli/mpw'

alias ix="curl -F 'f:1=<-' http://ix.io"
alias sprunge="curl -F 'sprunge=<-' http://sprunge.us"

alias reload='source ${HOME}/.zshrc'
