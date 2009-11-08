#!/bin/bash
# A basically sane bash environment.
#
# Ryan Tomayko <http://tomayko.com/about> (with help from the internets).

# setup some basic variables
: ${HOME=~}
: ${LOGNAME=$(id -un)}
: ${UNAME=$(uname)}

# ----------------------------------------------------------------------
# CONFIGURATION
# ----------------------------------------------------------------------

# source /etc/bashrc?
: ${NO_SYSTEM_RC=}

# complete hostnames from
: ${HOSTFILE=~/.ssh/known_hosts}

# readline inputrc
: ${INPUTRC=~/.inputrc}


# ----------------------------------------------------------------------
#  SHELL OPTIONS
# ----------------------------------------------------------------------

# bring in global/system bashrc
test -z "$NO_SYSTEM_RC" -a -r /etc/bashrc &&
. /etc/bashrc

# notify bg job completion immediately
set -o notify

shopt -s cdspell >/dev/null 2>&1
shopt -s extglob >/dev/null 2>&1
shopt -s histappend >/dev/null 2>&1
shopt -s hostcomplete >/dev/null 2>&1
shopt -s interactive_comments >/dev/null 2>&1
shopt -u mailwarn >/dev/null 2>&1
shopt -s no_empty_cmd_completion >/dev/null 2>&1

unset MAILCHECK

# no core dumps
ulimit -S -c 0

# default umask
umask 0022

# ----------------------------------------------------------------------
# PATH
# ----------------------------------------------------------------------

# we want the various sbins on the path along with /usr/local/bin
PATH="$PATH:/usr/local/sbin:/usr/sbin:/sbin"
PATH="/usr/local/bin:$PATH"

# put ~/bin on PATH if you have it
test -d "$HOME/bin" &&
PATH="$HOME/bin:$PATH"

# ----------------------------------------------------------------------
# ENVIRONMENT CONFIGURATION
# ----------------------------------------------------------------------

# detect interactive shell
case "$-" in
    *i*) INTERACTIVE=1 ;;
    *)   unset INTERACTIVE ;;
esac

# detect login shell
case "$0" in
    -*) LOGIN=1 ;;
    *)  unset LOGIN ;;
esac

# enable en_US locale w/ utf-8 encodings if not already configured
: ${LANG:="en_US.UTF-8"}
: ${LANGUAGE:="en"}
: ${LC_CTYPE:="en_US.UTF-8"}
: ${LC_ALL:="en_US.UTF-8"}
export LANG LANGUAGE LC_CTYPE LC_ALL

# Always use PASSIVE mode ftp
: ${FTP_PASSIVE:=1}
export FTP_PASSIVE

# Ignore backups, CVS directories, python bytecode, vim swap files
FIGNORE="~:CVS:#:.pyc:.swp:.swa:apache-solr-*"
HISTCONTROL=ignoreboth

# ----------------------------------------------------------------------
# PAGER / EDITOR
# ----------------------------------------------------------------------

# See what we have to work with ...
HAVE_VIM=$(command -v vim)
HAVE_GVIM=$(command -v gvim)

# EDITOR
test -n "$HAVE_VIM" &&
EDITOR=vim ||
EDITOR=vi
export EDITOR

# PAGER
if test -n "$(command -v less)" ; then
    PAGER="less -FirSwX"
    MANPAGER="less -FiRswX"
else
    PAGER=more
    MANPAGER="$PAGER"
fi
export PAGER MANPAGER

# ----------------------------------------------------------------------
# PROMPT
# ----------------------------------------------------------------------

RED="\[\033[0;31m\]"
BROWN="\[\033[0;33m\]"
GREY="\[\033[0;37m\]"
BLUE="\[\033[0;34m\]"
PS_CLEAR="\[\033[0m\]"
SCREEN_ESC="\[\033k\033\134\]"

if [ "$LOGNAME" = "root" ]; then
    COLOR1="${RED}"
    COLOR2="${BROWN}"
    P="#"
else
    COLOR1="${BLUE}"
    COLOR2="${BROWN}"
    P="\$"
fi

prompt_simple() {
    unset PROMPT_COMMAND
    PS1="[\u@\h:\w]\$ "
    PS2="> "
}

prompt_compact() {
    unset PROMPT_COMMAND
    PS1="${COLOR1}${P}${PS_CLEAR} "
    PS2="> "
}

prompt_color() {
    PS1="${GREY}[${COLOR1}\u${GREY}@${COLOR2}\h${GREY}:${COLOR1}\W${GREY}]${COLOR1}$P${PS_CLEAR} "
    PS2="\[[33;1m\]continue \[[0m[1m\]> "
}

# ----------------------------------------------------------------------
# MacOS X / Darwin
# ----------------------------------------------------------------------

if [ "$UNAME" = Darwin ]; then
    # put ports on the paths if /opt/local exists
    test -x /opt/local && {
        PORTS=/opt/local

        # setup the PATH and MANPATH
        PATH="$PORTS/bin:$PORTS/sbin:$PATH"
        MANPATH="$PORTS/share/man:$MANPATH"

        # nice little port alias
        alias port="sudo nice -n +18 $PORTS/bin/port"
    }

    # setup java environment. puke.
    JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Home"
    ANT_HOME="/Developer/Java/Ant"
    export ANT_HOME JRUBY_HOME

    # hold jruby's hand
    test -d /opt/jruby &&
    JRUBY_HOME="/opt/jruby"
    export JRUBY_HOME
fi

# ----------------------------------------------------------------------
# ALIASES / FUNCTIONS
# ----------------------------------------------------------------------

# disk usage with human sizes and minimal depth
alias du1='du -h --max-depth=1'
alias fn='find . -name'
alias hi="history | tail -20"

# ----------------------------------------------------------------------
# BASH COMPLETION
# ----------------------------------------------------------------------

if test -z "$BASH_COMPLETION" ; then
    bash=${BASH_VERSION%.*}; bmajor=${bash%.*}; bminor=${bash#*.}
    if [ "$PS1" ] && [ $bmajor -gt 1 ] ; then
        # search for a bash_completion file to source
        for f in /usr/pkg/etc/back_completion \
            /usr/local/etc/bash_completion \
            /opt/local/etc/bash_completion \
            /etc/bash_completion \
            ~/.bash_completion ;
        do
            if test -f $f; then
                . $f
                break
            fi
        done
    fi
    unset bash bmajor bminor
fi

# override and disable tilde expansion
_expand() {
    return 0
}

# ----------------------------------------------------------------------
# COLOR UTILS
# ----------------------------------------------------------------------

LS_COMMON="-hBG"
if test -n "$dircolors"; then
    COLORS=/etc/DIR_COLORS
    test -e "/etc/DIR_COLORS.$TERM"   && COLORS="/etc/DIR_COLORS.$TERM"
    test -e "$HOME/.dircolors"        && COLORS="$HOME/.dircolors"
    test -e "$HOME/.dircolors.$TERM"  && COLORS="$HOME/.dircolors.$TERM"
    test -e "$HOME/.dir_colors"       && COLORS="$HOME/.dir_colors"
    test -e "$HOME/.dir_colors.$TERM" && COLORS="$HOME/.dir_colors.$TERM"
    test ! -e "$COLORS"               && COLORS=
    eval `$dircolors --sh $COLORS`
fi
unset dircolors

if test -n "$LS_COLORS"; then
    alias ll="/bin/ls -l $LS_COMMON"
    alias l.="/bin/ls -d $LS_COMMON .*"
    alias ls="/bin/ls $LS_COMMON"
fi

# gnu() {
#     basename $(type -P "$@" false | head -1)
# }

# prefer GNU version of most core utilities from the shell.
# alias awk=$(gnu gawk gnuawk awk)
# alias base64=$(gnu gbase64 base64)
# alias basename=$(gnu gbasename basename false)
# alias cat=$(gnu gcat cat false)
# alias cp=$(gnu gcp cp false)
# alias cut=$(gnu gcut cut false)
# alias date=$(gnu gdate date)
# alias df=$(gnu gdf df)
# alias du=$(gnu gdu du)
# alias head=$(gnu ghead head)
# alias join=$(gnu gjoin join)
# alias md5sum=$(gnu gmd5sum md5sum)
# alias mv=$(gnu gmv mv)
# alias nl=$(gnu gnl nl)
# alias paste=$(gnu gpaste paste)
# alias printf=$(gnu gprintf printf)
# alias readlink=$(gnu greadlink readlink)
# alias rm=$(gnu grm rm)
# alias seq=$(gnu gseq seq)
# alias sha1sum=$(gnu gsha1sum sha1sum)
# alias sleep=$(gnu gsleep sleep)
# alias sort=$(gnu gsort sort)
# alias split=$(gnu gsplit split)
# alias tac=$(gnu gtac tac)
# alias tail=$(gnu gtail tail)
# alias tar=$(gnu gnutar gtar tar)
# alias tee=$(gnu gtee tee)
# alias touch=$(gnu gtouch touch)
# alias tr=$(gnu gtr tr)
# alias uniq=$(gnu guniq uniq)
# alias uptime=$(gnu guptime uptime)
# alias wc=$(gnu gwc wc)
# alias who=$(gnu gwho who)
# alias whoami=$(gnu gwhoami whoami)


# --------------------------------------------------------------------
# MISC COMMANDS
# --------------------------------------------------------------------

# push SSH public key to another box
push_ssh_cert() {
    local _host
    test -f ~/.ssh/id_dsa.pub || ssh-keygen -t dsa
    for _host in "$@";
    do
        echo $_host
        ssh $_host 'cat >> ~/.ssh/authorized_keys' < ~/.ssh/id_dsa.pub
    done
}

# -------------------------------------------------------------------
# USER SHELL ENVIRONMENT
# -------------------------------------------------------------------

test -r ~/.shenv &&
. ~/.shenv

# Use the color prompt by default
test -n "$PS1" &&
prompt_color

# -------------------------------------------------------------------
# MOTD / FORTUNE
# -------------------------------------------------------------------

test -n "$INTERACTIVE" -a -n "$LOGIN" && {
    uname -npsr
    uptime
}

# vim: ts=4 sts=4 shiftwidth=4 expandtab
