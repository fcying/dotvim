#!/bin/sh

#https://github.com/vim/vim.git 

cd `dirname $0`
if [ ! -d "../vim_origin" ]; then
    git clone https://github.com/vim/vim.git ../vim_origin --depth 2
    cd ../vim_origin/
else
    echo "git fetch"
    cd ../vim_origin/
    git fetch origin master
    git reset --hard origin/master
fi

echo "start build vim"
if [ $(uname | grep MINGW -c) -eq 1 ]; then
    mingw32-make.exe distclean
    cd src
	mingw32-make.exe -f Make_ming.mak ARCH=x86-64 \
					FEATURES=huge \
					GUI=no \
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
					MBYTE=yes \
					IME=yes \
					CSCOPE=yes \
					POSTSCRIPT=yes \
					PYTHON=/d/tools/python/Python27 PYTHON_VER=27 DYNAMIC_PYTHON=yes \
					PYTHON3=/d/tools/python/Python35 PYTHON3_VER=35 DYNAMIC_PYTHON3=yes \
					LUA=/d/tools/Lua/523 LUA_VER=52 DYNAMIC_LUA=yes \
					USERNAME=JasonYing USERDOMAIN=JasonYing-PC
	mkdir ../../vim74                
	cp -vR ../runtime/* ../../vim74/
	cp -v *.exe ../../vim74/
	gvim.exe --version
else
	sudo make distclean
	./configure --with-features=huge \
				--enable-multibyte \
				--enable-cscope \
				--enable-gui=no \
				--enable-rubyinterp \
				--enable-pythoninterp \
				--enable-python3interp \
				--enable-perlinterp \
				--enable-luainterp \
				--prefix=/usr \
				| tee log
	sudo make
	sudo make install
    vim --version | grep -E \(python\|lua\)
fi


