#!/bin/sh

cd `dirname $0`
if [ ! -d "../vim_origin" ]; then
    git clone https://github.com/vim/vim.git ../vim_origin --depth 2
    cd ../vim_origin/
else
    echo "git fetch"
    cd ../vim_origin/
    git fetch -v --progress --depth 2 origin master
    git reset --hard origin/master
fi

git clean -fxd
echo "start build vim"
if [ $(uname | grep MINGW -c) -eq 1 ]; then
    mingw32-make.exe distclean
    cd src
    mingw32-make.exe -f Make_ming.mak ARCH=x86-64 \
                    FEATURES=huge \
                    GUI=no \
                    OLE=yes \
                    DIRECTX=yes \
                    MBYTE=yes \
                    IME=yes \
                    CSCOPE=yes \
                    POSTSCRIPT=yes \
                    PYTHON=/d/tools/python/Python27 PYTHON_VER=27 DYNAMIC_PYTHON=yes \
                    PYTHON3=/d/tools/python/Python35 PYTHON3_VER=35 DYNAMIC_PYTHON3=yes \
                    LUA=/d/tools/Lua/523 LUA_VER=52 DYNAMIC_LUA=yes \
                    USERNAME=JasonYing USERDOMAIN=JasonYing-PC
    mingw32-make.exe -f Make_ming.mak ARCH=x86-64 \
                    FEATURES=huge \
                    GUI=yes \
                    OLE=yes \
                    DIRECTX=yes \
                    MBYTE=yes \
                    IME=yes \
                    CSCOPE=yes \
                    POSTSCRIPT=yes \
                    PYTHON=/d/tools/python/Python27 PYTHON_VER=27 DYNAMIC_PYTHON=yes \
                    PYTHON3=/d/tools/python/Python35 PYTHON3_VER=35 DYNAMIC_PYTHON3=yes \
                    LUA=/d/tools/Lua/523 LUA_VER=52 DYNAMIC_LUA=yes \
                    USERNAME=JasonYing USERDOMAIN=JasonYing-PC
    vim_version=vim80
    mkdir ../../$vim_version                
    cp -vR ../runtime/* ../../$vim_version/
    cp -v *.exe ../../$vim_version/
    cp -v xxd/xxd.exe ../../$vim_version/
    cp -v GvimExt/gvimext.dll ../../$vim_version/
    gvim.exe --version
else
    sudo make distclean
    ./configure --with-features=huge \
                --enable-multibyte \
                --enable-cscope \
                --enable-gui=no \
                --enable-rubyinterp=dynamic \
                --enable-pythoninterp=dynamic \
                --enable-python3interp=dynamic \
                --enable-perlinterp=dynamic \
                --enable-luainterp=dynamic \
                --prefix=/usr \
                --with-features=huge \
                --with-compiledby=JasonYing
                
    sudo make
    sudo make install
    vim --version #| grep -E \(python\|lua\)
fi


