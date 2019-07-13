#!/bin/bash

cd $(dirname $0)
config_dir=$PWD

if [ -f $HOME/.zshrc.local ]; then
    sed -i "/CONFIG_DIR/d" $HOME/.zshrc.local
fi
echo "CONFIG_DIR=$config_dir" | tee -a $HOME/.zshrc.local
ln -sfv $PWD/zshrc ~/.zshrc
ln -sfv $PWD/bashrc ~/.bashrc
ln -sfv $PWD/inputrc ~/.inputrc
ln -sfv $PWD/tigrc ~/.tigrc
ln -sfv $PWD/tmux.conf ~/.tmux.conf

# nvim
mkdir -p ~/.config/nvim
echo "set nvim init.vim"
rm -f ~/.config/nvim/init.vim
echo "source ~/.vim/vimrc" > ~/.config/nvim/init.vim
# windows: $HOME\AppData\Local\nvim\init.vim

# linuxbrew
function linuxbrew_ln() {
    bin_path=$HOMEBREW_PREFIX/bin/$1
    if [ -f "$bin_path" ]; then
        ln -svf $bin_path ~/bin
    fi
}
if [ -n "$HOMEBREW_PREFIX" ]; then
    linuxbrew_ln ccls
    linuxbrew_ln ctags
    linuxbrew_ln cmake
    linuxbrew_ln docker-langserver
    linuxbrew_ln global
    linuxbrew_ln go
    linuxbrew_ln godoc
    linuxbrew_ln gofmt
    linuxbrew_ln gtags
    linuxbrew_ln lua
    linuxbrew_ln nnn
    linuxbrew_ln node
    linuxbrew_ln npm
    linuxbrew_ln nvim
    linuxbrew_ln pip3
    linuxbrew_ln pygmentize
    linuxbrew_ln python3
    linuxbrew_ln pandoc
    linuxbrew_ln rg
    linuxbrew_ln tig
    linuxbrew_ln tmux
    linuxbrew_ln vim
    linuxbrew_ln vimdiff
    linuxbrew_ln w3m
    linuxbrew_ln zsh
fi

# pip.conf
#mkdir -p ~/.config/pip
#rm -vf ~/.config/pip/pip.conf
#ln -sfv $PWD/pip.conf ~/.config/pip

# windows: $HOME\_vimrc   #use this doesn't load defaults.vim

