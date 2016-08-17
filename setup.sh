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
echo "[1;32m"
cat <<'EOF'
 _      _                        
| | ___| |_ ___  ___ _ __   __ _ 
| |/ __| __/ __|/ _ \ '_ \ / _` |
| | (__| |_\__ \  __/ | | | (_| |
|_|\___|\__|___/\___|_| |_|\__, |
                           |___/ 
EOF
echo "[1;0m"
echo "[1;91mATTENTION!![1;0m"
echo "Remember to modify [1;91m.gitconfig[1;0m to set your own name and email address."
echo "Or you can run '[1;91mgit config --global user.name \"Your Name\"[1;0m' to set your name,"
echo "and '[1;91mgit config --global user.email you@example.com[1;0m' to set your email address"

username=`whoami`
if [ "${username}" != "lctseng" ]; then
  echo "[Git configuration]"
  echo "It seems that your name is not lctseng."
  while true;
  do
    echo -n "Do you change the settings for git? [1;91m[y/N][1;0m "
    read cmd
    if [ "${cmd}" = "y" -o "${cmd}" = "Y" ]; then
      echo -n "Enter your name (default: [1;91m${username}[1;0m): "
      read new_name
      if [ ${#new_name} -eq 0 ]; then
        new_name=$username
      fi
      echo "Changed git name to [1;91m${new_name}[1;0m"
      git config --global user.name "${new_name}"
      echo -n "Enter your email (left empty to keep the old one): "
      read new_email
      if [ ${#new_email} -eq 0 ]; then
        echo "Keeps the old email settings"
      else
        echo "Changed git email to [1;91m${new_email}[1;0m"
        git config --global user.email "${new_email}"
      fi
      break
    elif [ "${cmd}" = "n" -o  "${cmd}" = "N" -o ${#cmd} -eq 0 ]; then
      echo "Skipping change configuration for git."
      break
    else 
      echo "Unknown choice. Please enter either 'y' or 'n'"
    fi
  done
fi
