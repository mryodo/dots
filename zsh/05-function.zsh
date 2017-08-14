#!/usr/bin/zsh

cd ()
{
    builtin cd "$@" && \
        ls -ha --color=auto -F
}

duh ()
{
    du -h --max-depth=1 "$@" | \
        sort -k 1,1hr -k 2,2f 
}

pathadd ()
{
    [ -d "$1" ] && \
        [[ ":$PATH:" != *":$1:"* ]] && \
        PATH="${PATH:+"$PATH:"}$1" 
}
