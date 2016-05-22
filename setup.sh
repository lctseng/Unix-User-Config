#!/bin/sh -e
echo "[Initializing]"
# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
BASEPATH=$(dirname "$SCRIPT")

# Update submodule
echo "[Updateing git submodules]"
cd $BASEPATH && git submodule update --init --recursive

# Link if target is not the same as 
# Link two directory 
echo "[Linking files and directories]"
for filename in .zkbd .vim .tcshrc .zshrc .gitconfig .screenrc .tmux.conf; do
  if [ -e ~/$filename ]; then
    DIFF=$(diff -rq ~/$filename $BASEPATH/$filename) 
    if [ "$DIFF" != "" ] ; then
      # they need backup
      echo "Backup: ~/$filename as  ~/$filename.old"
      mv ~/$filename ~/$filename.old
      echo "Create: $filename"
      ln -s $BASEPATH/$filename ~/$filename
    else
      echo "No changed: $filename"
    fi
  else
    echo "Create: $filename"
    ln -s $BASEPATH/$filename ~/$filename
  fi
done
# Link vimrc
filename=vimrc
if [ -e ~/.$filename ]; then
  DIFF=$(diff -rq ~/.$filename ~/.vim/$filename) 
  if [ "$DIFF" != "" ] ; then
    # they need backup
    echo "Backup: ~/.$filename as  ~/.$filename.old"
    mv ~/.$filename ~/.$filename.old
    echo "Create: .$filename"
    ln -s ~/.vim/$filename ~/.$filename
  else
    echo "No changed: .$filename"
  fi
else
  echo "Create: .$filename"
  ln -s ~/.vim/$filename ~/.$filename
fi

# Compile Command-T
OS_TYPE=`uname`
if [ $OS_TYPE == "FreeBSD" ]; then
  GNU_MAKE=gmake
else
  GNU_MAKE=make
fi
cd $BASEPATH/.vim/bundle/command-t/ruby/command-t
$GNU_MAKE clean
ruby extconf.rb
$GNU_MAKE
