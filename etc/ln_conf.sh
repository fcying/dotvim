#!/bin/bash

cd $(dirname $0)
config_dir=$PWD

if [ -f $HOME/.zshrc.local ]; then
    sed -i "/CONFIG_DIR/d" $HOME/.zshrc.local
fi
echo "CONFIG_DIR=$config_dir" | tee -a $HOME/.zshrc.local
ln -sfv $PWD/zshrc ~/.zshrc
ln -sfv $PWD/bashrc ~/.bashrc
ln -sfv $PWD/inputrc ~/.inputrc
ln -sfv $PWD/tigrc ~/.tigrc
ln -sfv $PWD/tmux.conf ~/.tmux.conf
ln -sfv $PWD/npmrc ~/.npmrc

# nvim
mkdir -p ~/.config/nvim
echo "set nvim init.vim"
rm -f ~/.config/nvim/init.vim
echo "source ~/.vim/vimrc" > ~/.config/nvim/init.vim
# windows: $HOME\AppData\Local\nvim\init.vim

# npm
type npm >/dev/null 2>&1 && {
    #npm config set registry http://registry.npm.taobao.org/
    #npm config set registry https://mirrors.huaweicloud.com/repository/npm/
    mkdir -p ~/.npm
    #cd ~/.npm
    #npm install cnpm --registry=https://registry.npm.taobao.org
}

# pip.conf
#mkdir -p ~/.config/pip
#rm -vf ~/.config/pip/pip.conf
#ln -sfv $PWD/pip.conf ~/.config/pip

# windows: $HOME\_vimrc   #use this doesn't load defaults.vim

