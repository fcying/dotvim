#!/bin/bash

set -e

cd `dirname $0`

cd ..
vim_home=$PWD

sudo=true
update=false
install=false
branch=""
prefix=/usr/local

TEMP=`getopt -o "ip::u::" -- "$@"`
eval set -- "$TEMP"
while true; do
    case "$1" in
        -i) install=true; shift;;
        -u) if [ "$2" != "" ]; then
                branch=$2
            fi
            update=true
            shift 2;;
        -p) if [ "$2" != "" ]; then
                prefix="$2"
            else
                prefix=$HOME/tool/vim
            fi
            mkdir -p $prefix
            sudo=false
            shift 2;;
        --) break;
    esac
done

#exit 0

if [ $(uname | grep MINGW -c) -eq 1 ]; then
    sudo=false
fi

if [ "$sudo" == "true" ]; then
    sudo echo "start"  #entry sudo passwd
fi

if [ $install == "true" ]; then
    if [ $(uname | grep MINGW -c) -eq 1 ]; then
        echo "os MSYS2"
        pacman -S mingw-w64-x86_64-lua
        #pacman -S mingw-w64-x86_64-python2
        #pacman -S mingw-w64-x86_64-python3
    elif [ $(uname -a | grep MANJARO -c) -eq 1 ]; then
        echo "os MANJARO"
    else
        echo "os Ubuntu"
        sudo apt install libncurses5-dev
        sudo apt install libxt-dev
        #sudo apt install libgnome2-dev libgnomeui-dev libgtk2.0-dev libcairo2-dev libx11-dev libxpm-dev libatk1.0-dev
        sudo apt install python3-dev python2.7-dev lua5.2 liblua5.2-dev
    fi
fi

if [ $install == "true" ] || [ $update == "true" ]; then
    if [ ! -d "$vim_home/vim_origin" ]; then
        git clone https://github.com/vim/vim.git vim_origin --depth=1
        cd $vim_home/vim_origin/
    else
        echo "git fetch"
        cd $vim_home/vim_origin/
        git clean -fxd
        git fetch -p -v --progress --depth=1 origin master
        if [ "$branch" != "" ]; then
            git reset --hard origin/master
            git reset --hard "$branch"
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
                     
    vim_version=vim81
    mkdir -p $vim_home/$vim_version                
    cp -vR ../runtime/* ../../$vim_version/
    cp -v *.exe $vim_home/$vim_version  
    cp -v xxd/xxd.exe $vim_home/$vim_version  
    cp -vf GvimExt/gvimext.dll $vim_home/$vim_version  
    cd $vim_home/$vim_version
    ./gvim.exe --version
else
    make distclean
    ./configure \
                --with-features=huge \
                --enable-gui=no \
                --with-x \
                --enable-xterm_clipboard \
                --enable-multibyte \
                --enable-cscope \
                --enable-rubyinterp=dynamic \
                --enable-pythoninterp=dynamic \
                --enable-python3interp=dynamic \
                --enable-luainterp=dynamic \
                --enable-perlinterp=dynamic \
                --prefix=$prefix \
                --with-compiledby=fcying 2>&1 |tee build.log
    p=`cat /proc/cpuinfo | grep -c processor`
    make -j$[p/2]

    if [ $sudo == "true" ]; then
        sudo make install
    else
        make install
    fi
    echo prefix: $prefix
    vim --version
fi
