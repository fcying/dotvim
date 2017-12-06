#!/bin/bash

set -e

cd `dirname $0`

cd ..
vim_home=$PWD

if [ "$1" == "all" ]; then
    if [ $(uname | grep MINGW -c) -eq 1 ]; then
        pacman -S mingw-w64-x86_64-lua
        #pacman -S mingw-w64-x86_64-python2
        #pacman -S mingw-w64-x86_64-python3
    else
        sudo apt install libncurses5-dev
        sudo apt install python3-dev python2.7-dev lua5.2 liblua5.2-dev
    fi
fi

if [ "$1" == "all" ] || [ "$1" == "update" ]; then
    if [ ! -d "$vim_home/vim_origin" ]; then
        #git clone https://github.com/vim/vim.git vim_origin --depth 100
        git clone https://github.com/vim/vim.git vim_origin
        cd $vim_home/vim_origin/
    else
        echo "git fetch"
        cd $vim_home/vim_origin/
        git clean -fxd
        #git fetch -v --progress --depth 100 origin master
        git fetch
        if [ "$2" != "" ]; then
            git reset --hard origin/master
            git reset --hard $2
        else
            git reset --hard origin/master
        fi
    fi
else
    cd $vim_home/vim_origin/
    git clean -fxd
fi

echo "start build vim"
if [ $(uname | grep MINGW -c) -eq 1 ]; then
    cd src
    export LUA=/mingw64/bin
    export LUA_VER=53
    export DYNAMIC_LUA=yes
    export PYTHON=/d/tool/python/Python27
    export DYNAMIC_PYTHON=yes
    export PYTHON3=/d/tool/python/Python35
    export DYNAMIC_PYTHON3=yes
    export ARCH=x86-64
    export OLE=yes
    export FEATURES=huge
    export DIRECTX=yes
    export MBYTE=yes
    export IME=yes
    export CSCOPE=yes
    export POSTSCRIPT=yes
    export USERNAME=JasonYing
    export USERDOMAIN=JasonYing-PC
    
    mingw32-make.exe -f Make_ming.mak GUI=yes
    mingw32-make.exe -f Make_ming.mak GUI=no
                     
    vim_version=vim80
    mkdir -p $vim_home/$vim_version                
    cp -vR ../runtime/* ../../$vim_version/
    cp -v *.exe $vim_home/$vim_version  
    cp -v xxd/xxd.exe $vim_home/$vim_version  
    cp -vf GvimExt/gvimext.dll $vim_home/$vim_version  
    cd $vim_home/$vim_version
    ./gvim.exe --version
else
    sudo make distclean
    ./configure \
                --enable-gui=no \
                --with-features=huge \
                --enable-multibyte \
                --enable-cscope \
                --enable-rubyinterp=dynamic \
                --enable-pythoninterp=dynamic \
                --enable-python3interp=dynamic \
                --enable-perlinterp=dynamic \
                --enable-luainterp=dynamic \
                --with-compiledby=JasonYing 2>&1 |tee build.log
                
    sudo make
    sudo make install
    vim --version
fi
