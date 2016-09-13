#!/bin/sh

cd `dirname $0`

#mkdir ../bundle
#cd ../bundle
#git clone https://github.com/Shougo/neobundle.vim

if [ $(uname | grep MINGW -c) -eq 1 ]; then
    mkdir -p $USERPROFILE/vimfiles/autoload
    curl -fLo $USERPROFILE/vimfiles/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
else
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi  
