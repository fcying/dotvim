#! /bin/bash
#
# Copyright (C) 2019 fcying <fcying@gmail.com>
#

if [ -d "$HOME/.linuxbrew/bin" ]; then
    HOMEBREW_PREFIX=$HOME/.linuxbrew
elif [ -d "/home/linuxbrew/.linuxbrew/bin" ]; then
    HOMEBREW_PREFIX=/home/linuxbrew/.linuxbrew
fi

# linuxbrew
function linuxbrew_ln() {
    bin_path=$HOMEBREW_PREFIX/bin/$1
    if [ -f "$bin_path" ]; then
        ln -svf $bin_path ~/bin
    fi
}

if [ -n "$HOMEBREW_PREFIX" ]; then
    linuxbrew_ln ccls
    linuxbrew_ln ctags
    linuxbrew_ln cmake
    linuxbrew_ln docker-langserver
    linuxbrew_ln global
    linuxbrew_ln gtags
    linuxbrew_ln lua
    linuxbrew_ln nnn
    linuxbrew_ln vifm
    linuxbrew_ln node
    linuxbrew_ln npm
    linuxbrew_ln nvim
    linuxbrew_ln pygmentize
    linuxbrew_ln pandoc
    linuxbrew_ln rg
    linuxbrew_ln rustc
    linuxbrew_ln cargo
    linuxbrew_ln tig
    linuxbrew_ln tmux
    linuxbrew_ln vim
    linuxbrew_ln vimdiff
    linuxbrew_ln w3m
    linuxbrew_ln zsh
fi
