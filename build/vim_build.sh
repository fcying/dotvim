#!/bin/bash

set -e

cd `dirname $0`

cd ..
vim_home=$PWD

sudo=true
update=false
install=false
for var 
do
    if [ "$var" == "prefix" ]; then
        sudo=false
    elif [ "$var" == "install" ]; then
        install=true
    elif [ "$var" == "update" ]; then
        update=true
    fi
done
    
if [ "$sudo" == "true" ]; then
    sudo echo "start"  #entry sudo passwd
fi

if [ $install == "true" ]; then
    if [ $(uname | grep MINGW -c) -eq 1 ]; then
        pacman -S mingw-w64-x86_64-lua
        #pacman -S mingw-w64-x86_64-python2
        #pacman -S mingw-w64-x86_64-python3
    else
        sudo apt install libncurses5-dev
        sudo apt install python3-dev python2.7-dev lua5.2 liblua5.2-dev
    fi
fi

if [ $install == "true" ] || [ $update == "true" ]; then
    if [ ! -d "$vim_home/vim_origin" ]; then
        #git clone https://github.com/vim/vim.git vim_origin --depth 100
        git clone https://github.com/vim/vim.git vim_origin
        cd $vim_home/vim_origin/
    else
        echo "git fetch"
        cd $vim_home/vim_origin/
        git clean -fxd
        #git fetch -v --progress --depth 100 origin master
        git fetch -p
        if [ "$2" != "" ]; then
            git reset --hard origin/master
            git reset --hard $2
        else
            git reset --hard origin/master
        fi
    fi
else
    cd $vim_home/vim_origin/
fi

# for xshell mouse wheel
sed -i "/^\s*held_button = MOUSE_RELEASE;$/d" src/term.c

echo "start build vim"
if [ $(uname | grep MINGW -c) -eq 1 ]; then
    cd src
    export LUA=d:/tool/lua
    export LUA_VER=52
    export DYNAMIC_LUA=yes
    export PYTHON=d:/tool/python/Python27
    export DYNAMIC_PYTHON=yes
    export PYTHON3=d:/tool/python/Python3
    export DYNAMIC_PYTHON3=yes
    export ARCH=x86-64
    export OLE=yes
    export FEATURES=huge
    export DIRECTX=yes
    export MBYTE=yes
    export IME=yes
    export GIME=yes
    export DYNAMIC_IME=yes
    export CSCOPE=yes
    export DEBUG=no
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
    make distclean
    if [ $sudo == "true" ]; then
        prefix=/usr/local
    else
        prefix=$HOME/tool/vim
    fi
    mkdir -p $prefix
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
                --prefix=$prefix \
                --with-compiledby=fcying 2>&1 |tee build.log
                
    make
    if [ $sudo == "true" ]; then
        sudo make install
    else
        make install
    fi
    echo prefix: $prefix
    vim --version
fi
