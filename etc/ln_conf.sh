#!/bin/bash

cd `dirname $0`

ln -sfv $PWD/zprofile ~/.zprofile
ln -sfv $PWD/zshrc ~/.zshrc
ln -sfv $PWD/bashrc ~/.bashrc
ln -sfv $PWD/tigrc ~/.tigrc
ln -sfv $PWD/tmux.conf ~/.tmux.conf
ln -sfv $PWD/antigen.rc ~/.antigen.rc
ln -sfv $PWD/ripgreprc ~/.ripgreprc

# nvim
mkdir -p ~/.config/nvim
rm -vf ~/.config/nvim/init.vim
echo "source ~/.vim/vimrc" > ~/.config/nvim/init.vim
# windows: $HOME\AppData\Local\nvim\init.vim

# pip.conf
mkdir -p ~/.config/pip
rm -vf ~/.config/pip/pip.conf
ln -sfv $PWD/pip.conf ~/.config/pip

# windows: $HOME\_vimrc   #use this doesn't load defaults.vim

