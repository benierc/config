#
# ~/.bashrc
# __CLEMENT_BENIER__
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#NO BEEP
xset -b

# Bash completion
if [ -f /etc/bash_completion.d/git-completion.bash ]; then
    source /etc/bash_completion.d/git-completion.bash
    source /etc/bash_completion.d/git-prompt.sh
fi

alias ls='ls --color=auto'
#default
#PS1='[\u@\h \W]\$ '
########PROMPT##########
TIME="\D{%H:%M}"
WHITE='\[\e[1;30m\]'
RED="\[\e[1;31m\]"
GREEN='\[\e[1;32m\]'
YELLOW='\[\e[1;33m\]'
BLUE='\[\e[1;34m\]'
PURPLE='\[\e[1;35m\]'
KK='\[\e[1;36m\]'
#USER='\u'
CURRENT_PATH='\w'
COLOR_OFF='\[\e[m\]'
PROMPT_CHARACTER='\$'
NAME='\W'

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=
export GIT_PS1_SHOWUNTRACKEDFILES=
export GIT_PS1_SHOWUPSTREAM= #auto #verbose name legacy git svn
export GIT_PS1_DESCRIBE_STYLE= #contains branch describe default

export PS1="${BLUE}[$TIME]${RED}${GREEN}[${USER} ${YELLOW}${NAME}${COLOR_OFF}${BLUE}${COLOR_OFF}${GREEN}]${RED}"'$(__git_ps1 "(%s)")'"${GREEN}${PROMPT_CHARACTER}${COLOR_OFF}${KK}"
source /etc/profile.d/vte.sh
PROMPT_COMMAND=__vte_prompt_command

sh $HOME/.screenlayout/classic.sh

#completion sudo

#alias
alias l='ls'
alias ll='ls -lh'
alias lla='ll -a'
function formatpatch {
    if [ "$1" ]; then
        git format-patch -M -n -s -o $1 origin/master
    fi
}

#official export
export EDITOR=vim
export MANPAGER="`which most`"
export PATH=$PATH:/home/clement/scriptbin/bin:/home/clement/bin
export HISTTIMEFORMAT='%F %T  '
export HISTCONTROL=ignoredups
export export HISTSIZE=9999999999999999999
#personnal export
export DOWNLOADS=$HOME/Downloads
export TOSEND=$HOME/Tosend
export FREENIVI=$HOME/work/freenivi/projet/freenivi/work/freenivi-os
export EFL=$HOME/work/efl
export PATH=$PATH:/home/clement/work/efl/bin:/home/clement/bin
export WWWDOKU="/home/clement/work/efl/www-content"
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
export CORB=$HOME/corbeille

#set -o vi

function create_dir {
    local cdate=$1
    local mounth=${cdate::7}
    if [ ! -d "$CORB/$mounth" ]; then
        mkdir $CORB/$mounth
    fi
    local day=${cdate:8:2}
    if [ ! -d "$CORB/$mounth/$day" ]; then
        mkdir $CORB/$mounth/$day
    fi
    local hour=${cdate:11}
    if [ ! -d "$CORB/$mounth/$day/$hour" ]; then
        mkdir $CORB/$mounth/$day/$hour
    fi
    res=$CORB/$mounth/$day/$hour
}
function move2corbeille {
    local currentdate=$(date +%F-%H-%M)
    create_dir $currentdate
    tdir=$res
    mv $* $tdir
}

function clean_corbeille {
    /bin/rm -fr $CORB/*
}

function scanreseau {
    getip=$(ip route | awk ' $1=="default" {print $7}')
    if [ -z "$1" ]; then
        scanip="$getip/24"
    else
        scanip="$getip/$1"
    fi
    echo "nmap -sP $scanip"
    nmap -sP $scanip
}

function scanreseaudiff {
    if [ -z "$1" ]; then
        optreseau=$1
    else
        optreseau=
    fi
    firstfilereseau="/tmp/scanreseaufirst"
    secondfilereseau="/tmp/scanreseausecond"
    res1="/tmp/resreseau1"
    res2="/tmp/resreseau2"
    if [ ! -e "$firstfilereseau" ];then
        scanreseau $optreseau > $firstfilereseau
    else
        scanreseau $optreseau > $secondfilereseau
        diff $firstfilereseau $secondfilereseau | awk '$2=="Nmap" && $3=="scan" {print $NF}' > $res2
        if [ ! -e "$res1" ]; then
            mv $res2 $res1
        else
            diff $res1 $res2
        fi
        mv $secondfilereseau $firstfilereseau
        cat $firstfilereseau
    fi
}
alias lin='wine ~/.wine/drive_c/lint/lint-nt.exe'
export LIN_INCLUDE_PATH="/usr/include/qt/*"
#alias rm=move2corbeille

#astuces
ASTUCES=$HOME/astuces
RAC_CONSOLE=$ASTUCES/raccourcis_console.txt
LESSER_KNOWN_CMD=$ASTUCES/lesser_known_commands.txt
alias rac_console='cat $RAC_CONSOLEi && echo && cat $LESSER_KNOWN_CMD'
port_lafp=8003
alias nlab='ssh -L $port_lafp:lafp-builder:22 cbenier@daviel.openwide.fr'
alias lafp='ssh cbenier@localhost -p $port_lafp'
alias proxyP2S='ssh -L 8003:P2S:22 cbenier@daviel.openwide.fr'
alias proxylafpbuilder='ssh -L 8004:lafp-builder:22 cbenier@daviel.openwide.fr'
alias proxyjenkins='ssh -L 8080:jenkins-lafp:8080 cbenier@daviel.openwide.fr'
#alias proxyjenkins='ssh -L 8100:jenkins-lafp:8100 cbenier@daviel.openwide.fr'
export NEXTER="/home/clement/NEXTER"
export Nexter="/home/clement/NEXTER"
lafpapps=$NEXTER/lafp-apps
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$lafpapps/notify/src:$lafpapps/abstraction/src:$lafpapps/trt_clim/src
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$NEXTER/passerellecan/libcandbc/lib

#function git {
#    if [ "$1" == "pull" ]; then
#        shift
#        echo "-> /usr/bin/git pull --rebase $*"
#        /usr/bin/git pull --rebase $*
#    else
#        /usr/bin/git $*
#    fi
#}
