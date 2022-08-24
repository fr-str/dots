# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:/usr/local/go/bin:/home/$USER/go/bin:/home/$USER/.local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"


ZSH_THEME="refined"
PLUGIN_PATH="${ZSH_CUSTOM1:-$ZSH/custom}/plugins"

plugins=(git kubectl docker sudo history dirhistory alias-tips  update-plugin linus-rants)
# for zsh_codex
zle -N create_completion
bindkey '^X' create_completion
# ------------
if [[ ! -d $PLUGIN_PATH ]]; then
  mkdir -p $PLUGIN_PATH
fi
function installSource(){
  if [[ ! -d $PLUGIN_PATH/$1 ]]; then
    git clone $2 $PLUGIN_PATH/$1 &
  fi
}

# install stuff
installSource zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions
installSource autopair https://github.com/hlissner/zsh-autopair
installSource alias-tips https://github.com/djui/alias-tips.git
installSource fast-syntax-highlighting https://github.com/zdharma-continuum/fast-syntax-highlighting
installSource linus-rants https://github.com/bhayward93/Linus-rants-ZSH.git
installSource update-plugin https://github.com/AndrewHaluza/zsh-update-plugin.git

source $PLUGIN_PATH/autopair/autopair.zsh
autopair-init
source $PLUGIN_PATH/zsh-autosuggestions/zsh-autosuggestions.zsh
source $PLUGIN_PATH/autojump/autojump.zsh
source $PLUGIN_PATH/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $ZSH/oh-my-zsh.sh
$(which k3d) &>> /dev/null
if [[  $? -eq 0 ]]; then 
  source <(k3d completion zsh)
fi

autoload -U colors && colors
# check if root
PS1="%(?.%F{green}.%F{red})❯ %f"
su=sudo
if [ "$UID" -eq 0 ]; then
  PS1="%F{cyan}%n %(?.%F{green}.%F{red})❯ %f"
  su=""
fi
if [ "$USER" = "fs" ]; then
  PS1="%F{cyan}server:%n %(?.%F{green}.%F{red})❯ %f"
fi


mkdir -p /tmp/home-tmp
#env
export CODE_PATH=~/timoni-07
export DATA_PATH=~/timoni-07/core/data
export CSCE=dev
export DOCKER_BUILDKIT=1
#kubeconfig
alias get-all-configs='f(){ v=$(find ~/.k3d/ -maxdepth 1 | tail -n +2 |xargs | sed "s/ /:/g");if [ -z "$v" ]; then;echo "$HOME/.kube/config";else;echo "$v:$HOME/.kube/config";fi; }; f'
export KUBECONFIG=$(get-all-configs)

#aliases----
eval $(thefuck --alias)
#arch
alias pacman="sudo pacman"
# debian
alias aptt="$su apt -y"
# fedora
alias dnff="$su dnf -y"
# git
alias gst="git status"
alias gsps="git stash && git pull && git stash pop"
# compileDeamon
alias gocd='f(){ CompileDaemon -build="$2" -directory="$3" -include="*.sh" -color=true -log-prefix=false -command="$1" -command-stop=true; }; f'
alias recd='f(){ CompileDaemon -build="" -directory="/home/$USER/timoni-07" -include="*.sh" -color=true -log-prefix=false -command="/home/$USER/.starter -command-stop true" -exclude-dir=.git }; f'
# else
alias cat="bat"
alias w="watch -n 1"
alias k="kubectl"
alias expl="xdg-open"
alias sss="ssh server"
alias rag=". ranger"

alias gic="git clone"
alias code-cleanup="cc"
alias fix-mod="find . -not -path '*/vendor/*' -name 'go.mod' -printf '%h\n' -execdir sh -c 'go mod tidy; go mod vendor; go fmt .' \;"
alias rr="rm -rf"
alias upgo="$su ~/.update-golang/update-golang.sh"
alias mkdircd='f(){ mkdir -p $1 && cd $1 }; f'
# -----------------------------------------------------------------------------
alias prptmp="cd /tmp/home-tmp && mkdir gotmp; cd gotmp && echo 'package main

func main() {
	
}'>> main.go && go mod init test && code ." 
alias math='f(){ echo "$1" | bc; }; f'

# -----------------------------------------------------------------------------

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

# function autocorrect() {
#     #zle .spell-word
#     #zle .$WIDGET
#     # Replace ? with --help flag
#     if [[ "$BUFFER" =~ '^(-?\w\s?)+\?$' ]]; then
#         BUFFER="${BUFFER::-1} --help"
#     fi

#     # If --help flag found, pipe output through bat
#     if [[ "$BUFFER" =~ '^(-?\w\s?)+ --help$' ]]; then
#         BUFFER="$BUFFER | bat -p -l help"
#     fi

#     # # press enter
#     zle accept-line
# }

#zle -N accept-line autocorrect
#zle -N magic-space autocorrect
#bindkey ' ' magic-space

zle -N help
bindkey '^J' help
bindkey '^M' help
