#!/bin/sh

cd `dirname $0`
cd ../bundle/YouCompleteMe/
git fetch origin master
git reset --hard origin/master
git submodule update --init --recursive

if [ $(uname | grep MINGW -c) -eq 1 ]; then
    mkdir build
    cd build 

    #rm -rf ./* && cmake -G "MSYS Makefiles" -DCMAKE_MAKE_PROGRAM=mingw32-make.exe -DPATH_TO_LLVM_ROOT=C:/LLVM -DPYTHON_LIBRARY=D:/tools/python/Python35/libs/python35.lib -DPYTHON_INCLUDE_DIR=D:/tools/python/Python35/include -DUSE_PYTHON2=OFF . ../third_party/ycmd/cpp
    #rm -rf ./* && cmake -G "MSYS Makefiles" -DCMAKE_MAKE_PROGRAM=mingw32-make.exe -DPATH_TO_LLVM_ROOT=C:/LLVM -DPYTHON_LIBRARY=D:/tools/python/Python27/libs/python27.lib -DPYTHON_INCLUDE_DIR=D:/tools/python/Python27/include -DUSE_PYTHON2=ON . ../third_party/ycmd/cpp

    rm -rf ./* && cmake -G "MSYS Makefiles" -DCMAKE_MAKE_PROGRAM=mingw32-make.exe -DPATH_TO_LLVM_ROOT=C:/LLVM . ../third_party/ycmd/cpp && cmake --build . --target ycm_core --config Release
else
    python3 install.py --clang-completer
fi
