# Adapted from code found at <https://gist.github.com/1712320>.

bindkey -e

setopt prompt_subst
autoload -U colors && colors # Enable colors in prompt
export TERM="screen"

stty -ixon

# Modify the colors and symbols in these variables as desired.
GIT_PROMPT_SYMBOL="%{$fg_bold[blue]%}±"
GIT_PROMPT_PREFIX="%{$fg_bold[green]%}[%{$reset_color%}"
GIT_PROMPT_SUFFIX="%{$fg_bold[green]%}]%{$reset_color%}"
GIT_PROMPT_AHEAD="%{$fg_bold[red]%}ANUM%{$reset_color%}"
GIT_PROMPT_BEHIND="%{$fg_bold[cyan]%}BNUM%{$reset_color%}"
GIT_PROMPT_MERGING="%{$fg_bold[magenta]%}⚡︎%{$reset_color%}"
GIT_PROMPT_UNTRACKED="%{$fg_bld[red]%}●%{$reset_color%}"
GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%}●%{$reset_color%}"
GIT_PROMPT_STAGED="%{$fg_bold[green]%}●%{$reset_color%}"

# Show Git branch/tag, or name-rev if on detached head
parse_git_branch() {
  (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}

# Show different symbols as appropriate for various Git repository states
parse_git_state() {

  # Compose this value via multiple conditional appends.
  local GIT_STATE=""

  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
  fi

  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_BEHIND" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}
  fi

  #local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  #if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
  #  GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
  #fi

  #if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
  #  GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
  #fi

  #if ! git diff --quiet 2> /dev/null; then
  #  GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
  #fi

  if ! git diff --cached --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
  fi

  if [[ -n $GIT_STATE ]]; then
    echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
  fi

}

# If inside a Git repository, print its branch and state
git_prompt_string() {
  local git_where="$(parse_git_branch)"
  #[ -n "$git_where" ] && echo "$GIT_PROMPT_PREFIX%{$fg[yellow]%} ${git_where#(refs/heads/|tags/)}$GIT_PROMPT_SUFFIX"
  [ -n "$git_where" ] && echo "$GIT_PROMPT_SYMBOL$(parse_git_state)$GIT_PROMPT_PREFIX%{$fg_bold[yellow]%}${git_where#(refs/heads/|tags/)}$GIT_PROMPT_SUFFIX"
}

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd extendedglob nomatch
unsetopt beep

# Histroy
autoload -Uz history-beginning-search-menu
zle -N history-beginning-search-menu
bindkey '^X^X' history-beginning-search-menu


autoload zkbd


# for tmux-screen nesting
bindkey -s "\e[1~" "\eOH"
bindkey -s "\e[4~" "\eOF"
bindkey -s "\e\e[D" "\e[1;3D"
bindkey -s "\e\e[C" "\e[1;3C"

if [[ -e ${ZDOTDIR:-$HOME}/.zkbd/screen-general ]]; then
  source ${ZDOTDIR:-$HOME}/.zkbd/screen-general
fi

[[ -n ${key[Backspace]} ]] && bindkey "${key[Backspace]}" backward-delete-char
[[ -n ${key[Insert]} ]] && bindkey "${key[Insert]}" overwrite-mode
[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
[[ -n ${key[PageUp]} ]] && bindkey "${key[PageUp]}" up-line-or-history
[[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
[[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
[[ -n ${key[PageDown]} ]] && bindkey "${key[PageDown]}" down-line-or-history
[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" up-line-or-search
[[ -n ${key[Left]} ]] && bindkey "${key[Left]}" backward-char
[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" down-line-or-search
[[ -n ${key[Right]} ]] && bindkey "${key[Right]}" forward-char


#bindkey -v
#bindkey "${terminfo[khome]}" beginning-of-line
#bindkey "${terminfo[kend]}" end-of-line

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
#zstyle :compinstall filename '~/.zshrc'

#autoload -Uz compinit
#compinit
# End of lines added by compinstall


# alias and env
export EDITOR=vim
alias write='env LC_CTYPE=en_US.ISO8859-1 write'
alias talk='env LC_CTYPE=en_US.ISO8859-1 talk'
alias wall='env LC_CTYPE=en_US.ISO8859-1 wall'
alias bs2='ssh bbsu@ssh.bs2.to'
alias p_all='pushd . ; cd ~ ; cd .. ; ls  | tr -d "/" | xargs -n1 -I $ user $ ; popd'
alias 'cd..'='cd ..'
alias 'cd-'='cd -'
alias cls='clear'
alias sr='screen -RD'
alias sd='screen -d'
alias nctucs='ssh lctseng@nctucs.tw'
alias csduty='ssh csduty'
alias cshome='ssh cshome'
alias linux='ssh linux3'
alias bsd='ssh bsd5'
alias csbackup='ssh csbackup'
alias csmail='ssh csmail'
alias csmailer='ssh csmailer'
alias tmr='tmux attach'
alias cs-help='ssh help -p 222'
alias ll='ls -al'
alias grep='grep --color=auto'

export LS_COLORS=':no=00:fi=00:di=01;31:ln=01;36:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:ex=01;32:*.cmd=01;32:*.exe=01;32:*.com=01;32:*.btm=01;32:*.bat=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.jpg=01;35:*.gif=01;35:*.bmp=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.c=01;33:*.cpp=01;33:*.MP3=01;44;37:*.mp3=01;44;37:*.pl=01;33:';
export LSCOLORS='DxGxFxdxCxegedabagacad'
export LC_CTYPE='zh_TW.UTF-8'
export LANG='zh_TW.UTF-8'
export LC_ALL='zh_TW.UTF-8'
#export LC_CTYPE='zh_TW.Big5'
#export LANG='zh_TW.Big5'
#export LC_ALL='zh_TW.Big5'
export RUBY_VERSION_PATCH=`ruby -e 'puts "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"'`

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
autoload -Uz compinit
compinit


# Platform-dependent settings
uname=`uname`
if [[ $uname == "Linux" ]]; then
  alias ls='ls --color=auto'
  first_ip=`ip addr | sed -e '/127\.0\.0\.1/d' | awk '/inet .*/{print $2}' | sed 1q | awk -F/ '{print $1}'`
else
  alias ls='ls -G'
  first_ip=`ifconfig | sed -e '/127\.0\.0\.1/d' | awk '/inet .* netmask/{print $2}' | sed 1q | sed -n '1,1p'`
fi



if [ -n ${prompt} ]; then
  ip_str='N/A'
  if [ -n ${first_ip} ]; then
    ip_str=${first_ip}
  fi
  window_str='[XD]'
  if [ -n "${WINDOW}" ]; then
    window_str="[W${WINDOW}]"
  fi
  prompt='%{$fg_bold[cyan]%}%T %{$fg_bold[yellow]%}%n%{$reset_color%}@%{$fg_bold[white]%}%m%{$reset_color%}%{$fg_bold[red]%}($ip_str)%{$fg_bold[green]%}[%~]%{$reset_color%} $(git_prompt_string)
%{$fg_bold[magenta]%}$window_str %{$reset_color%}%# '
fi






function zle-line-init {
    marking=0
}
zle -N zle-line-init

function select-char-right {
    if (( $marking != 1 )) 
    then
        marking=1
        zle set-mark-command
    fi
    zle .forward-char
}
zle -N select-char-right

function select-char-left {
    if (( $marking != 1 )) 
    then
        marking=1
        zle set-mark-command
    fi
    zle .backward-char
}
zle -N select-char-left

function forward-char {
    if (( $marking == 1 ))
    then
        marking=0
        NUMERIC=-1 zle set-mark-command
    fi
    zle .forward-char
}
zle -N forward-char

function backward-char {
    if (( $marking == 1 ))
    then
        marking=0
        NUMERIC=-1 zle set-mark-command
    fi
    zle .backward-char
}
zle -N backward-char

function delete-char {
    if (( $marking == 1 ))
    then
        zle kill-region
        marking=0
    else
        zle .delete-char
    fi
}
zle -N delete-char

bindkey '^[[1;3D' select-char-left 
bindkey '^[[1;3C' select-char-right
bindkey "\C-w" delete-char


# Syntax highlight
source ~/Unix-User-Config/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
typeset -A ZSH_HIGHLIGHT_STYLES
fg_green='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[command]=$fg_green
ZSH_HIGHLIGHT_STYLES[alias]=$fg_green
ZSH_HIGHLIGHT_STYLES[builtin]=$fg_green

## rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
# Load rbenv automatically by appending
# the following to ~/.zshrc:
eval "$(rbenv init -)"

# Proxy
export HTTP_PROXY="192.168.2.91:80"
export HTTPS_PROXY="192.168.2.91:80"
export FTP_PROXY="192.168.2.91:80"


export http_proxy="192.168.2.91:80"
export https_proxy="192.168.2.91:80"
export ftp_proxy="192.168.2.91:80"
