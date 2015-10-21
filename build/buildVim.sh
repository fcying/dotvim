#!/bin/sh

cd ../vim_origin/src

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
cd ../

gvim.exe --version

