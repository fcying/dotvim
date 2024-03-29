#!/bin/bash

set -e

cd `dirname $0`

cd ..
vim_home=$PWD
vim_src=build/.vim_origin

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
    sudo echo "sudo start"  #entry sudo passwd
fi

if [ ! -d "$vim_home/$vim_src" ]; then
    update=true
    install=true
fi

if [ $install == "true" ]; then
    if [ "$sudo" == "true" ]; then
        if [ $(uname | grep MINGW -c) -eq 1 ]; then
            echo "os MSYS2"
            pacman -S --noconfirm mingw-w64-x86_64-lua
            #pacman -S --noconfirm mingw-w64-x86_64-python2
            #pacman -S --noconfirm mingw-w64-x86_64-python3
        elif [ $(uname -a | grep MANJARO -c) -eq 1 ]; then
            echo "os MANJARO"
        else
            echo "os Ubuntu/debian"
            sudo apt install -y build-essential libncurses5-dev libxt-dev \
                python3-dev luajit libluajit-5.1-dev
            #sudo apt install libgnome2-dev libgnomeui-dev libgtk2.0-dev libcairo2-dev libx11-dev libxpm-dev libatk1.0-dev
        fi
    fi
fi

if [ $install == "true" ] || [ $update == "true" ]; then
    if [ ! -d "$vim_home/$vim_src" ]; then
        git clone https://github.com/vim/vim.git $vim_src --depth=1
        cd $vim_home/$vim_src/
    else
        echo "git fetch"
        cd $vim_home/$vim_src/
        git clean -fxd
        git fetch -p -v --progress --depth=1 origin master
        if [ "$branch" != "" ]; then
            git reset --hard "$branch"
        else
            git reset --hard origin/master
        fi
    fi
else
    cd $vim_home/$vim_src/
    git clean -fxd
    git reset --hard HEAD
fi

# for xshell mouse wheel; fix in the latest version
#sed -i "/^\s*held_button = MOUSE_RELEASE;$/d" src/term.c

echo "======================================================"
echo "start build vim; prefix: $prefix"
echo "======================================================"

if [ $(uname | grep MINGW -c) -eq 1 ]; then
    cd src
    export LUA=d:/tool/lua
    export LUA_VER=52
    export DYNAMIC_LUA=yes
    export PYTHON3=d:/tool/python/Python3
    export PYTHON3_VER=39
    export DYNAMIC_PYTHON3=yes
    export ARCH=x86-64
    export OLE=yes
    export FEATURES=huge
    export DIRECTX=yes
    export MBYTE=yes
    export IME=yes
    export GIME=yes
    export DYNAMIC_IME=yes
    export DEBUG=no
    export POSTSCRIPT=yes
    export USERNAME=fcying

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
    config="--with-features=huge \
--enable-gui=no \
--enable-multibyte \
--enable-rubyinterp=dynamic \
--enable-python3interp --with-python3-command=python3 \
--enable-luainterp \
--with-luajit \
--enable-perlinterp=dynamic \
--prefix=$prefix \
--with-compiledby=fcying"
#--with-x \
#--enable-python3interp --with-python3-command=python3 \
#--enable-python3interp=dynamic \

    echo "======================================================"
    echo "build config: $config"
    echo "======================================================"

    ./configure $config
    p=`cat /proc/cpuinfo | grep -c processor`
    p=$[p/2]
    if [ $p == 0 ]; then
        p=1
    fi
    make -j$p

    if [ $sudo == "true" ]; then
        sudo make install
    else
        make install
    fi
    cd $prefix/bin
    if [ $prefix != "/usr/local" ]; then
        ln -svf $(pwd)/vim ~/bin
        ln -svf $(pwd)/vimdiff ~/bin
        ln -svf $(pwd)/xxd ~/bin
    fi

    ./vim --version
fi
