#!/usr/bin/env bash

# install cli xcode tools
if [ ! -x /usr/bin/gcc ]; then
    xcode-select --install
fi

# only install brew if we need to (https://brew.sh)
if [ ! $(which brew) ]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Brewfile is in the same directory as the bootstrap.sh script
brew update && brew bundle

# setup dotfiles
if [ ! -d ~/.dotfiles ]; then
    git clone git@bitbucket.org:hexaddikt/dotfiles.git .dotfiles
    pushd ~/.dotfiles
    rake install
    popd
fi

if [ ! -f ~/.vim/autoload/plug.vim ]; then
    # install vim-plug
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    vim +PluginInstall +qall
fi


echo "----------- DONE -----------"
