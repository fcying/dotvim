#!/bin/bash

cd $(dirname $0)
config_dir=$PWD

app="ln"
if [ -n "$1" ]; then
    app=$1
fi

if [[ $app == "ln" ]]; then
    # nvim
    mkdir -p ~/.config/nvim
    if [ $(echo $PWD | grep -c "\.vim") -eq 1 ]; then
        ln -svf $PWD/../vimrc ~/.config/nvim/init.vim
    fi

    if [ -f $HOME/.zshrc.local ]; then
        sed -i "/CONFIG_DIR/d" $HOME/.zshrc.local
    fi
    echo "CONFIG_DIR=$config_dir" | tee -a $HOME/.zshrc.local

    ln -sfv $PWD/zshrc ~/.zshrc
    ln -sfv $PWD/bashrc ~/.bashrc
    ln -sfv $PWD/bashenv ~/.bashenv
    ln -sfv $PWD/dircolors ~/.dircolors
    ln -sfv $PWD/inputrc ~/.inputrc
    ln -sfv $PWD/tmux.conf ~/.tmux.conf

    mkdir -p ~/.config/tig
    ln -sfv $PWD/tigrc ~/.config/tig/config

fi

# windows
#mkdir %userprofile%\AppData\Local\nvim
#echo source d:\tool\vim\vimrc > %userprofile%\AppData\Local\nvim\init.vim
#echo source d:\tool\vim\vimrc > %userprofile%\_vimrc   #use this doesn't load defaults.vim

# npm
if [[ $app == "npm" ]]; then
    type npm >/dev/null 2>&1 && {
        npm config set registry https://repo.huaweicloud.com/repository/npm/
        mkdir -p ~/.npm
    }
fi

# pypi mirror
if [[ $app == "pip" ]]; then
    PYPI=https://opentuna.cn/pypi/web/simple
    pip3 install -i $PYPI pip -U
    pip3 config set global.index-url $PYPI
fi


