#:depends-on:nix
cat <<'EOP'
             :
    `.       ;        .'
      `.  .-'''-.   .'
        ;'  __   _;'
       /   '_    _`\
      |  _( a (  a  |
 '''''| (_)    >    |``````
       \    \    / /
        `.   `--'.'
       .' `-,,,-' `.
     .'      :      `.  hjw
             :
EOP

# echo "begin zshrc"
echo "shell session started for $USER on $TTY at `date`" | tee /dev/stderr | logger

source $HOME/.localzshrc.sh

autoload -U colors && colors
autoload zsh/parameter
autoload -Uz vcs_info
autoload -U add-zsh-hook
autoload run-help
autoload -U zfinit
autoload -U tcp_proxy
autoload -U tcp_open
autoload -U tcp_point
autoload -U tcp_shoot
autoload -Uz compinit
autoload edit-command-line

setopt allexport
setopt autocd
setopt autolist
setopt autopushd
setopt nobeep
setopt cdablevars
setopt nochaselinks
setopt completeinword
setopt histexpiredupsfirst
setopt histignorealldups
setopt histverify
setopt listpacked
setopt markdirs
setopt nobgnice
setopt promptsubst
setopt pushdignoredups
setopt sharehistory

export GNU_PREFIX=''
platform="$(uname -s)"
echo the platform is "$platform"
if [[ $platform == 'Darwin' ]]; then
	GNU_PREFIX='g'
else
   echo not osx
fi

export INFOPATH=/usr/local/share/info:/usr/local/texlive/2009/texmf/doc/info

export VIMCLOJURE_SERVER_JAR="$HOME/bin/jars/server-2.3.6.jar"
export SAVEHIST=10000000
export HISTSIZE=10000000
export HISTFILE=$HOME/.zshistory

export PKG_CONFIG_PATH="$PKG_CONFIG_PATH"

export MANPATH="/opt/local/share/man:/Applications/Xcode.app/Contents/Developer/usr/share/man:$MANPATH"

export PAGER="less -SiemX"

export RGBDEF='/opt/X11/share/X11/rgb.txt'
export GREP_COLORS='ms=01;31:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36'

if command -v emacsclient 2>&1 >/dev/null; then
    export VISUAL="emacsclient -c"
elif [ -x /usr/local/bin/vim ]; then
    export VISUAL="/usr/local/bin/vim"
else
    export VISUAL="/usr/bin/vim"
fi
export EDITOR=$VISUAL

#------------------
zfinit

alias vi='vim'
vim() {
    stty -ixon
    env vim $*
    stty ixany
}
alias :e="$VISUAL"
alias :w='cat >'

alias "cd-"="cd -"
alias jmp=pushd
alias ret=popd
alias grep="grep --color=auto -I"
alias la="ls -AF"
alias ,=pydit
alias v=$VISUAL
alias e=$EDITOR
alias cvsdiff='cvs diff -wbB | colordiff'
alias cp.="${GNU_PREFIX}cp --target-directory=."
alias find='noglob find'

showspaces() {
    python -c'import sys;print sys.stdin.read().replace(" ","_").replace("\t", "----")'
}

truncfile() {
    echo $1
    (( number = $1 - 1 ))
    ${GNU_PREFIX}sed -i "${number}q" $2
}

gtde() { cd $HOME/Desktop/$1 }
gtdo() { cd $HOME/Downloads/$1 }
gtp() {cd $HOME/Programming/$1 }
gt() { cd $HOME/$1 }
if [[ ! -e $HHOME/.gtaliases ]]; then touch $HOME/.gtaliases; fi

savedir() {
    cmd="export "`basename $PWD`"=$PWD"
    eval $cmd
    truncfile 50 $HOME/.gtaliases
    echo $cmd >> $HOME/.gtaliases
}

gtpa() {
    gtp $1
    cmd="alias \"gt_$1\"=\"gtp $1\""
    eval $cmd
    truncfile 50 $HOME/.gtaliases
    echo $cmd >> $HOME/.gtaliases
}
gta() {
    gt $1
    cmd="alias \"gt_$1\"=\"gt $1\""
    eval $cmd
    truncfile 50 $HOME/.gtaliases
    echo $cmd >> $HOME/.gtaliases
}
source $HOME/.gtaliases
gthaskell() { gtp haskell }
gtprolog() { gtp prolog }
gtpython() { gtp python }

despace() { echo ${1// /} }
escape() { echo ${(j<\\ >)*} }
archive() {
    if [ ! -d .bak ]; then
	mkdir .bak
    fi
    FN=".bak/${1// /}-`date +"%Y%m%d.%H%M%S"`.tbz"
    echo -n archiving $FN...
    tar jhcf $FN $1
    echo done.
}

editrc() {
    hash=`md5 $HOME/.zshrc`
    $VISUAL $HOME/.zshrc
    newhash=`md5 $HOME/.zshrc`
    if [[ $hash != $newhash ]]; then
	source $HOME/.zshrc
    fi
}

rl() { source $HOME/.zshrc }

getlink() { #gtdo
    curl "`pbpaste`" > $(basename `pbpaste`)
}

copypwd() { echo -n `pwd` | pbcopy }
alias sdir='copypwd'

sshto() {
    TARGET=`egrep "^$1:" ~/.ssh_dests | cut -d: -f2`
    USER=`grep $TARGET ~/.ssh_dests | cut -d: -f3`
    ssh $USER@$TARGET
}

dirsave() {
    pwd | ctext
}
dirgo() {
    cd `ptext`
}

ccwd() {
    pwd | ucopy
}

gdir() {
    cd `upaste`
}

ulimit -c unlimited
zle -N edit-command-line

add_to_sandbox() {
    echo adding $1 to sandbox
    cp "$1" "$HOME/sandbox"
    cd "$HOME/sandbox"
    git add "`basename $1`"
    git commit -a -m "added snippet $1"
    cd -
}

wiki() {
    pushd $HOME/mywiki > /dev/null
    soywiki
    popd > /dev/null
}

es() {
    python2.7 -c "e('$1')"
}

load_snippet() {
    python -ic "import sitecustomize;ls('$1')"
}

alias page="$PAGER"
export VIRTUALENV=/usr

export PYTHONPATH="$PYTHONPATH":"$HOME/pythonlibs"

getshelljobtrees() {
    pstree `pgrep '^login$'`
}


psgrep() {
    ps auxw | grep --color=yes $* | grep -v grep --color=no
}

dis() {
    jobs
    echo -n 'disown which? '
    n=-1
    read n
    if [[ ! -z "$n" ]]; then
	disown %$n
    fi
}

alias dq=dmenu_queue_mpd
alias dqp=dmenu_queueplay_mpd

set -o vi
bindkey -M vicmd '?' history-incremental-search-backward
bindkey '^X^e' edit-command-line
bindkey '^I' complete-word
bindkey -M viins '^Oc' _correct_word
bindkey -M viins '^O?' _complete_debug

# detecting the terminal to get the keybindings right
# TODO: check if obsoleted by other things
if [[ -z $BINDKEYS ]]; then
    # echo 'defining bindkeys in zshrc'
    BINDKEYS=${TERM%-256color}
    BINDKEYS=${BINDKEYS%-noit}
fi

bindkey -e
if [[ $BINDKEYS == "screen" ]]; then
    bindkey '[D' backward-word
    bindkey '[C' forward-word
    bindkey '[1~' beginning-of-line
    bindkey '[4~' end-of-line
else
    bindkey -M viins '[1;5D' backward-word
    # bindkey '[5D' backward-word
    bindkey -M viins '[1;5C' forward-word
    # bindkey '[5C' forward-word
    bindkey -M viins 'OH' beginning-of-line
    bindkey -M viins 'OF' end-of-line
fi
bindkey '[3~' delete-char

export GOPATH=$HOME/go

rvm use system &>/dev/null


export CPATH=$CPATH:$HOME/include
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/lib
export VIMCLOJURE_SERVER_JAR="$HOME/lib/vimclojure/server-2.3.6.jar"
export CLON_THEME=el