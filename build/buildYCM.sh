#!/bin/sh
cd ../bundle/YouCompleteMe/
mkdir build
cd build 
cmake -G "MSYS Makefiles" -DCMAKE_MAKE_PROGRAM=mingw32-make.exe -DPATH_TO_LLVM_ROOT=C:/LLVM . ../third_party/ycmd/cpp
mingw32-make ycm_support_libs
