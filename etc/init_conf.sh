#!/bin/bash

cd $(dirname $0)
config_dir=${PWD//$HOME/\$HOME}
echo $config_dir

app="ln"
if [ -n "$1" ]; then
    app=$1
fi

if [[ $app == "ln" ]]; then
    # nvim
    mkdir -p ~/.config/nvim
    if [ $(ls "$HOME/.config/nvim" | grep -c "init.lua") -eq 0 ]; then
        ln -svf $PWD/../init.lua ~/.config/nvim/init.lua
    fi

    if [ -f $HOME/.shrc.local ]; then
        sed -i --follow-symlinks "s|.*CONFIG_DIR=.*|export MY_CONFIG_DIR=$config_dir|" $HOME/.shrc.local
    else
        echo "MY_CONFIG_DIR=$config_dir" | tee $HOME/.shrc.local
    fi

    ln -sfv $PWD/zshrc ~/.zshrc
    ln -sfv $PWD/bashrc ~/.bashrc
    ln -sfv $PWD/dircolors ~/.dircolors
    ln -sfv $PWD/inputrc ~/.inputrc
    ln -sfv $PWD/editorconfig ~/.editorconfig

    mkdir -p ~/.tmux
    ln -sfv $PWD/tmux.conf ~/.tmux.conf
    ln -sfv $PWD/colortheme ~/.tmux

    mkdir -p ~/.config/tig
    ln -sfv $PWD/tigrc ~/.config/tig/config

    mkdir -p ~/.ctags.d
    ln -sfv $PWD/ctags ~/.ctags.d/global.ctags

    ln -sfv $PWD/.clangd ~/
    ln -sfv $PWD/.clang-format ~/

    mkdir -p ~/.config/nushell
    ln -sfv $PWD/nushell/*.nu ~/.config/nushell

    mkdir -p ~/.config/atuin
    ln -sfv $PWD/atuin/config.toml ~/.config/atuin/config.toml
fi

# windows
#mkdir %userprofile%\AppData\Local\nvim
#echo source d:\tool\vim\init.lua > %userprofile%\AppData\Local\nvim\init.vim
#echo source d:\tool\vim\init.lua > %userprofile%\_vimrc   #use this doesn't load defaults.vim

# npm
if [[ $app == "npm" ]]; then
    type npm >/dev/null 2>&1 && {
        npm config set registry https://repo.huaweicloud.com/repository/npm/
        mkdir -p ~/.npm
    }
fi

# pypi mirror
if [[ $app == "pip" ]]; then
    #PYPI=https://repo.huaweicloud.com/repository/pypi/simple
    PYPI=https://pypi.tuna.tsinghua.edu.cn/simple
    pip3 install -i $PYPI pip -U
    pip3 config set global.index-url $PYPI
fi


