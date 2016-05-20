#!/bin/sh -ev
# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
BASEPATH=$(dirname "$SCRIPT")
# Update submodule
git submodule update --init --recursive


# Link files
ln -s $BASEPATH/.vim ~/.vim
if [ -f ~/.vimrc ]; then
	# Backup old
	mv ~/.vimrc ~/.vimrc.old
fi
ln -s ~/.vim/vimrc ~/.vimrc
if [ -f ~/.tcshrc ]; then
	# Backup old
	mv ~/.tcshrc ~/.tcshrc.old
fi
ln -s $BASEPATH/.tcshrc ~/.tcshrc
if [ -f ~/.zshrc ]; then
	# Backup old
	mv ~/.zshrc ~/.zshrc.old
fi
ln -s $BASEPATH/.tcshrc ~/.tcshrc
if [ -f ~/.gitconfig ]; then
	# Backup old
	mv ~/.gitconfig ~/.gitconfig.old
fi
ln -s $BASEPATH/.gitconfig ~/.gitconfig
ln -s $BASEPATH/.screenrc ~/.screenrc
ln -s $BASEPATH/.tmux.conf ~/.tmux.conf
