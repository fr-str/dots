export PATH=$HOME/bin:/usr/local/bin:/usr/local/go/bin:/home/$USER/go/bin:/home/$USER/.local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="refined"
PLUGIN_PATH="${ZSH_CUSTOM1:-$ZSH/custom}/plugins"

plugins=(git kubectl docker sudo history dirhistory alias-tips update-plugin linus-rants command-not-found)

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
PS1="%F{cyan}server %(?.%F{green}.%F{red})❯ %f"
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
alias get-all-configs='f(){ v=$(find ~/.k3d/ -maxdepth 1 | tail -n +2 |xargs | sed "s/ /:/g");if [ -z "$v" ]; then;echo "$HOME/.kube/config";export KUBECONFIG=$HOME/.kube/config;else;echo "$v:$HOME/.kube/config";KUBECONFIG="$v:$HOME/.kube/config";fi; }; f'
export KUBECONFIG=$(get-all-configs)
export KUBE_CONFIG_FILE=$HOME/.k3d/kubeconfig-k3s-default.yaml
export LOGGER=dev

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
# compileDeamon
alias gocd='f(){ CompileDaemon -build="$2" -directory="$3" -include="*.sh" -include="*.toml" -color=true -log-prefix=false -command="$1" -command-stop=true; }; f'
alias ticd='f(){ CompileDaemon -build="" -directory="/home/$USER/timoni" -include="*.sh" -color=true -log-prefix=false -command="/home/$USER/timoni/1/ti-run.sh -command-stop true" -exclude-dir=.git }; f'
# else
alias cat="bat"
alias w="watch -n 1"
alias k="kubectl"
alias expl="xdg-open"
alias sss="ssh server"
alias rag=". ranger"
alias gic="git clone"
alias code-cleanup="cc"
alias fix-mod="find . -not -path '*/vendor/*' -name 'go.mod' -printf '%h\n' -execdir sh -c 'go mod tidy; go fmt .' \;"
alias rr="rm -rf"
alias upgo="$su ~/.update-golang/update-golang.sh"
alias mkdircd='f(){ mkdir -p $1 && cd $1 }; f'
alias lego="lego --path $HOME"
alias vim=nvim
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

    # If contains run, build, make or install, change govenor to performance 
    if [[ "$BUFFER" =~ $s ]]; then
        # sudo cpupower frequency-set -g performance > /dev/null
        # zle accept-line
    fi

    # press enter
    zle accept-line
}

function dupa() {
    if [[ last_command=$(fc -ln -1) =~ $s ]]; then
        # sudo cpupower frequency-set -g powersave > /dev/null
    fi
}

autoload -U add-zsh-hook
add-zsh-hook precmd dupa
#precmd_functions+=(changeGovernor)

zle -N help
bindkey '^J' help
bindkey '^M' help
bindkey '^ ' autosuggest-accept
# bindkey '^=' autosuggest-execute

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
