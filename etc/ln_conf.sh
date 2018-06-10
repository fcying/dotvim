#!/bin/bash

cd `dirname $0`

ln -sfv $PWD/zshrc ~/.zshrc
ln -sfv $PWD/tigrc ~/.tigrc
ln -sfv $PWD/tmux.conf ~/.tmux.conf
ln -sfv $PWD/antigen.rc ~/.antigen.rc

mkdir -p ~/.config/nvim
rm -vf ~/.config/nvim/init.vim
echo "source ~/.vim/vimrc" > ~/.config/nvim/init.vim
# windows: AppData\Local\nvim\init.vim

