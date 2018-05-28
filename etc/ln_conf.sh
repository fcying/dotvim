#!/bin/bash

cd `dirname $0`

ln -sfv $PWD/zshrc ~/.zshrc
ln -sfv $PWD/tigrc ~/.tigrc
ln -sfv $PWD/tmux.conf ~/.tmux.conf
ln -sfv $PWD/antigen.rc ~/.antigen.rc
