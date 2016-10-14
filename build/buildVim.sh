#!/bin/bash

cd `dirname $0`

cd ..
vim_home=$PWD

if [ "$1" = "all" ]; then
    if [ $(uname | grep MINGW -c) -eq 1 ]; then
        pacman -S mingw-w64-x86_64-lua
        pacman -S mingw-w64-x86_64-python2
        pacman -S mingw-w64-x86_64-python3
    else
        sudo apt install libncurses5-dev
        sudo apt install python3-dev python2.7-dev lua5.2 liblua5.2-dev
    fi
fi

if [ "$1" = "all" ] || [ "$1" = "update" ]; then
    if [ ! -d "$vim_home/vim_origin" ]; then
        git clone https://github.com/vim/vim.git ../vim_origin --depth 2
        cd $vim_home/vim_origin/
    else
        echo "git fetch"
        cd $vim_home/vim_origin/
        git fetch -v --progress --depth 2 origin master
        git reset --hard origin/master
    fi
fi

set -e

cd $vim_home/vim_origin/
git clean -fxd

echo "start build vim"
if [ $(uname | grep MINGW -c) -eq 1 ]; then
    cd src
    mingw32-make.exe -f Make_ming.mak ARCH=x86-64 \
                    GUI=yes \
                    OLE=yes \
                    FEATURES=huge \
                    DIRECTX=yes \
                    MBYTE=yes \
                    IME=yes \
                    CSCOPE=yes \
                    POSTSCRIPT=yes \
                    PYTHON=/d/tool/python/Python27 PYTHON_VER=27 DYNAMIC_PYTHON=yes \
                    PYTHON3=/d/tool/python/Python35 PYTHON3_VER=35 DYNAMIC_PYTHON3=yes \
                    LUA=/mingw64/bin LUA_VER=53 DYNAMIC_LUA=yes \
                    USERNAME=JasonYing USERDOMAIN=JasonYing-PC 2>&1 |tee build.log
    mingw32-make.exe -f Make_ming.mak ARCH=x86-64 \
                    GUI=no \
                    OLE=yes \
                    FEATURES=huge \
                    DIRECTX=yes \
                    MBYTE=yes \
                    IME=yes \
                    CSCOPE=yes \
                    POSTSCRIPT=yes \
                    PYTHON=/d/tool/python/Python27 PYTHON_VER=27 DYNAMIC_PYTHON=yes \
                    PYTHON3=/d/tool/python/Python35 PYTHON3_VER=35 DYNAMIC_PYTHON3=yes \
                    LUA=/mingw64/bin LUA_VER=53 DYNAMIC_LUA=yes \
                    USERNAME=JasonYing USERDOMAIN=JasonYing-PC 2>&1 |tee build.log
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
    vim --version #| grep -E \(python\|lua\)
fi


