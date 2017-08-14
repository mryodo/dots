#!/usr/bin/zsh

export EDITOR=nvim
export VISUAL=nvim


source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

for extra in $HOME/.zsh/[0-9]*.zsh
do
    source $extra
done



