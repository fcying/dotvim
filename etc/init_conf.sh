#!/bin/bash

cd $(dirname $0)
config_dir=$PWD
echo $PWD

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
        sed -i "/CONFIG_DIR/d" $HOME/.shrc.local
    fi
    echo "CONFIG_DIR=$config_dir" | tee -a $HOME/.shrc.local

    ln -sfv $PWD/zshrc ~/.zshrc
    ln -sfv $PWD/bashrc ~/.bashrc
    ln -sfv $PWD/bashenv ~/.bashenv
    ln -sfv $PWD/dircolors ~/.dircolors
    ln -sfv $PWD/inputrc ~/.inputrc
    ln -sfv $PWD/editorconfig ~/.editorconfig

    mkdir ~/.tmux
    ln -sfv $PWD/tmux.conf ~/.tmux.conf
    ln -sfv $PWD/colortheme ~/.tmux

    mkdir -p ~/.config/tig
    ln -sfv $PWD/tigrc ~/.config/tig/config

    mkdir -p ~/.config/clangd
    ln -sfv $PWD/clangd.yaml ~/.config/clangd/config.yaml

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


