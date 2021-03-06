#!/usr/bin/env bash

echo "This script needs SSH keys set up first"

if [ ! -d ~/.bootstrap ]; then
    mkdir ~/.bootstrap 
fi
pushd ~/.bootstrap

# install cli xcode tools
if [ ! -x /usr/bin/gcc ]; then
    xcode-select --install
fi

# only install brew if we need to (https://brew.sh)
if [ ! $(which brew) ]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

curl -fsSL https://raw.githubusercontent.com/jordanlabs/bootstrap/master/Brewfile -o Brewfile

# Brewfile is in the same directory as the bootstrap.sh script
brew update && brew bundle

# Gem installs
gem install rake rspec

# setup dotfiles
if [ ! -d ~/.dotfiles ]; then
    git clone git@bitbucket.org:hexaddikt/dotfiles.git ~/.dotfiles

    if [ $? -eq 0 ]; then
        pushd ~/.dotfiles
        rake install
        popd
    fi
fi

if [ ! -f ~/.vim/autoload/plug.vim ]; then
    # install vim-plug
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    vim +PlugInstall +qall
fi

popd
echo "----------- DONE -----------"
