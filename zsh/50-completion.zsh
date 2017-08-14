autoload -U compinit && compinit 

zstyle ':completion:*' list-dirs-first true
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select auto
zstyle ':completion:*' separate-sectoins false

zstyle ':completion::complete:*' cache-path $HOME/.cache/zcompcache
zstyle ':completion::complete:*' use-cache 1

zstyle ':completion:*:cd:*' ignored-patterns '(*/)#lost+found'

zstyle ':completion:*:*:mpv:*' file-sort name
zstyle ':completion:*:*:mpv:*' file-patterns \
    '*.(#i)(mp3|flac|alac|ape|ogg|wav|mkv|avi|webm|mp4|srt)(-.) *(-/):directories' \
    '*:all-files'
zstyle ':completion:*:*:mpv:*' tag-order '!urls'
zstyle ':completion:*:*:mpv:*' ignored-patterns '(memory)://'

zstyle ':completion:*:kill:*:process' list-colors '-(#b) #([0-9]#)*=0=01;31'

zstyle ':completion:*:processes' command 'ps -axw'
zstyle ':completion:*:processes-names' command 'ps -awxho command'
