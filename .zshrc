# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:/usr/local/go/bin:/home/$USER/go/bin:/home/$USER/.local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"


ZSH_THEME="refined"


plugins=(git kubectl docker sudo history dirhistory)

source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH/oh-my-zsh.sh

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
export CODE_PATH=~/rekuber-07
export DATA_PATH=~/rekuber-07/core/data
export CSCE=dev
export KUBECONFIG=~/.kube/config:~/.k3d/kubeconfig-k3s-default.yaml:~/.k3d/kubeconfig-upa.yaml

#aliases----
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
alias gocd='f(){ CompileDaemon -build="$2" -directory="$3" -include="*.sh" -color=true -log-prefix=false -command="$1" -command-stop true; }; f'
alias recd='f(){ CompileDaemon -build="" -directory="/home/$USER/rekuber-07" -include="*.sh" -color=true -log-prefix=false -command="/home/$USER/.starter -command-stop true" -exclude-dir=.git }; f'
# else
alias cat="bat"
alias w="watch -n 1"
alias k="kubectl"
alias expl="xdg-open"
alias sss="ssh server"
alias rag=". ranger"

alias gic="git clone"
alias fix-mod="find . -not -path '*/vendor/*' -name 'go.mod' -printf '%h\n' -execdir sh -c 'go mod tidy; go mod vendor; go fmt .' \;"
alias rr="rm -rf"
alias upgo="$su ~/.update-golang/update-golang.sh"
# -----------------------------------------------------------------------------
alias prptmp="cd /tmp/home-tmp && mkdir gotmp; cd gotmp && echo 'package main


func main() {
	
}'>> main.go && go mod init test && code ." 
# -----------------------------------------------------------------------------

# Arch Mirrors update
distro=$(source /etc/os-release; echo ${ID_LIKE:=$ID})
if [[ $distro == "arch" ]]; then
    alias updm-rate="sudo reflector -a 10 -c pl --sort rate --save /etc/pacman.d/mirrorlist"
    alias updm-score="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
fi


# function help {
#     # Replace ? with --help flag
#     if [[ "$BUFFER" =~ '^(-?\w\s?)+\?$' ]]; then
#         BUFFER="${BUFFER::-1} --help"
#     fi

#     # If --help flag found, pipe output through bat
#     if [[ "$BUFFER" =~ '^(-?\w\s?)+ --help$' ]]; then
#         BUFFER="$BUFFER | bat -p -l help"
#     fi

#     # press enter
#     zle accept-line
# }

function autocorrect() {
    zle .spell-word
    zle .$WIDGET
    # Replace ? with --help flag
    if [[ "$BUFFER" =~ '^(-?\w\s?)+\?$' ]]; then
        BUFFER="${BUFFER::-1} --help"
    fi

    # If --help flag found, pipe output through bat
    if [[ "$BUFFER" =~ '^(-?\w\s?)+ --help$' ]]; then
        BUFFER="$BUFFER | bat -p -l help"
    fi

    # # press enter
    # zle accept-line
}

zle -N accept-line autocorrect
zle -N magic-space autocorrect
bindkey ' ' magic-space

# zle -N help
# bindkey '^J' help
# bindkey '^M' help
