export PATH=$HOME/bin:/usr/local/bin:/usr/local/go/bin:/home/$USER/go/bin:/home/$USER/.local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="refined"
PLUGIN_PATH="${ZSH_CUSTOM1:-$ZSH/custom}/plugins"

plugins=(git kubectl docker sudo history dirhistory alias-tips update-plugin command-not-found)

if [[ ! -d $PLUGIN_PATH ]]; then
  mkdir -p $PLUGIN_PATH
fi
function installSource(){
  if [[ ! -d $PLUGIN_PATH/$1 ]]; then
    git clone $2 $PLUGIN_PATH/$1 &
  fi
}


# source $PLUGIN_PATH/autopair/autopair.zsh
# autopair-init
source $PLUGIN_PATH/zsh-autosuggestions/zsh-autosuggestions.zsh
# source $PLUGIN_PATH/autojump/autojump.zsh
source $PLUGIN_PATH/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $ZSH/oh-my-zsh.sh
$(which k3d) &>> /dev/null
if [[  $? -eq 0 ]]; then 
  source <(k3d completion zsh)
fi

autoload -U colors && colors
# check if root
PS1="%F{cyan}serverek %(?.%F{green}.%F{red})❯ %f"
su=sudo
if [ "$UID" -eq 0 ]; then
  PS1="%F{cyan}%n %(?.%F{green}.%F{red})❯ %f"
  su=""
fi

if [ "$USER" = "fs" ]; then
  PS1="%F{cyan}server:%n %(?.%F{green}.%F{red})❯ %f"
  alias shutdown="echo 'TY DEBILU'"
fi


mkdir -p /tmp/home-tmp
#env
export DOCKER_BUILDKIT=1
export EDITOR=nvim
#kubeconfig
# alias get-all-configs='f(){ v=$(find ~/.k3d/ -maxdepth 1 | tail -n +2 |xargs | sed "s/ /:/g");if [ -z "$v" ]; then;echo "$HOME/.kube/config";export KUBECONFIG=$HOME/.kube/config;else;echo "$v:$HOME/.kube/config";KUBECONFIG="$v:$HOME/.kube/config";fi; }; f'
# export KUBECONFIG=$(get-all-configs)
export KUBE_CONFIG_FILE=$HOME/.k3d/kubeconfig-k3s-default.yaml
export LOGGER=dev
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
# export SJ_LAST_COMMAND_LOG=""

#aliases----
eval $(thefuck --alias)
#arch
alias pacman="$su pacman"
# debian
alias aptt="$su apt -y"
# fedora
alias dnff="$su dnf -y"
# git
alias gst="git status"
alias gsps="git stash && git pull --rebase && git stash pop"
alias lg="lazygit"
# compileDeamon
alias gocd='f(){ CompileDaemon -build="$2" -directory="$3" -include="*.rs" -include="*.java" -include="*.sh" -include="*.toml" -color=true -log-prefix=false -command="$1" -command-stop=true; }; f'
# else
alias cat="bat"
alias forcoz='go build -ldflags=-compressdwarf=false -gcflags=all="-N -l"'
alias w="watch -n 1"
alias k="kubectl"
alias expl="xdg-open"
alias sss="ssh server"
alias rag=". ranger"
alias gic="git clone"
alias code-cleanup="cc"
alias fix-mod="find . -not -path '*/vendor/*' -name 'go.mod' -printf '%h\n' -execdir sh -c 'go mod tidy; go fmt .' \;"
alias rr="rm -rf"
alias upgo="dupa=$PWD && cd ~/.update-golang && git pull && $su ~/.update-golang/update-golang.sh && cd $dupa"
alias goline='f(){ go build -gcflags="-m $1"}; f'
alias gobce="go build -gcflags=-d=ssa/check_bce/debug=1"
alias mkdircd='f(){ mkdir -p $1 && cd $1 }; f'
alias lego="lego --path $HOME"
alias vim=nvim
alias amdctl="sudo amdctl"
alias leh=fuck
alias tldrf='tldr --list | fzf --preview "tldr {1} --color=always" --preview-window=right,70% | xargs tldr'
alias fzfv='fzf | xargs nvim'
alias prsync='parallelRsync $@'
# -----------------------------------------------------------------------------
alias prptmp="cd /tmp/home-tmp && mkdir gotmp; cd gotmp && echo 'package main

func main() {
	
}'>> main.go && go mod init test && code ." 
alias math='f(){ echo "$1" | bc; }; f'
# alias sj='f(){ [[ ! -d /tmp/sj ]] && mkdir /tmp/sj;  SJ_LAST_COMMAND_LOG="/tmp/sj/${1}.log";echo "duuu $@"; "$@" &> "/tmp/sj/${1}.log"; [[ ! $? -eq 0 ]] && bat "/tmp/sj/${1}.log"; }; f'
# alias sjlog='[[ ! -z $SJ_LAST_COMMAND_LOG ]] && bat $SJ_LAST_COMMAND_LOG'
# -----------------------------------------------------------------------------

isremote() {
    [[ "${1%%/*}" == *: ]] || [[ "${1%%~*}" == *: ]]
}

remoteTildeExpansion() {
    local expanded_path
    
    # Expand the tilde (~) to the home directory of the remote host if it is present in the path
    if [[ "$1" == *"~"* ]]; then
        expanded_path="${1/\~/$(ssh "${1%%:*}" 'echo $HOME')}"
    else
        expanded_path="$1"
    fi
    
    echo $expanded_path
}
parallelRsync() {
    local src="$1" dest="$2"
    shift 2 || { echo "missing arguments" >&2; return 1; }
    isremote "$src" && { echo "cannot handle remote source" >&2; return 1; }
    (
        isremote "$dest" && [[ ! "$dest" == /* ]] && dest=$(remoteTildeExpansion "$dest")
        [[ "$src" == */ ]] || dest="$dest/${src##*/}"
        echo "------------------ $dest ------------------"
        cd "$src" &&
        find . -type f -print0 |
        xargs -0 -P10 -I% rsync -PhR "$@" % "$dest";
    ) &&
    rsync -Ph "$@" "$src" "$dest"
}

function cc(){
  git fetch --prune
  branches=$(git branch -vv | grep ': gone]' | awk '{print $1}')

  if [ -z $branches ]; then
      echo "Nothing to do"
  fi
  echo $branches | xargs -n1 --no-run-if-empty git branch --delete --force
}


# Arch Mirrors update
distro=$(source /etc/os-release; echo ${ID_LIKE:=$ID})
if [[ $distro == "arch" ]]; then
    alias updm-rate="sudo reflector -a 10 -c pl --sort rate --save /etc/pacman.d/mirrorlist"
    alias updm-score="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
fi

s='(run|build|make|install|yay)'
function help {
    # Replace ? with --help flag
    if [[ "$BUFFER" =~ '^(-?\w\s?)+\?$' ]]; then
        BUFFER="${BUFFER::-1} --help"
    fi

    # If --help flag found, pipe output through bat
    if [[ "$BUFFER" =~ '^(-?\w\s?)+ --help$' ]]; then
        BUFFER="$BUFFER | bat -p -l help"
    fi
    
    # press enter
    zle accept-line
}

tmux-window-name() {
	($TMUX_PLUGIN_MANAGER_PATH/tmux-window-name/scripts/rename_session_windows.py &> /dev/null &)
}

autoload -U add-zsh-hook
add-zsh-hook chpwd tmux-window-name

zle -N help
bindkey '^J' help
bindkey '^M' help
bindkey '^.' autosuggest-accept
bindkey '^,' autosuggest-accept
# bindkey '^0' autosuggest-execute

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
