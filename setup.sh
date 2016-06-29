#!/bin/sh
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
echo "[Compiling Command-T]"
UNAME=`uname`
if [ $UNAME = "FreeBSD" ]; then
  GNU_MAKE=gmake
else
  GNU_MAKE=make
fi
echo "Use GNU MAKE from command: ${GNU_MAKE}"
# create a os version if not exists
COMMAND_T_BASE_PATH="$BASEPATH/.vim/bundle/command-t"
OS_TYPE="`uname -s`-`uname -m`"
RUBY_VERSION_PATCH=`ruby -e 'puts "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"'`
OS_RUBY_VERSION="ruby-platform-${OS_TYPE}-${RUBY_VERSION_PATCH}"

if [ ! -d $COMMAND_T_BASE_PATH/$OS_RUBY_VERSION  ]; then
  # not exists, create from template
  echo "Create a platform-dependent copy: $OS_RUBY_VERSION"
  cp -a $COMMAND_T_BASE_PATH/ruby $COMMAND_T_BASE_PATH/$OS_RUBY_VERSION
  cd "$COMMAND_T_BASE_PATH/$OS_RUBY_VERSION/command-t"
  echo "Compiling..."
  ruby extconf.rb
  $GNU_MAKE clean
  $GNU_MAKE
else
  echo "Already newest version"
fi
