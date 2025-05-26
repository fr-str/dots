export PATH=$HOME/.cargo/bin/:$HOME/bin:/usr/local/bin:/usr/local/go/bin:/home/$USER/go/bin:/home/$USER/.local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="refined"
PLUGIN_PATH="${ZSH_CUSTOM1:-$ZSH/custom}/plugins"

plugins=(git kubectl docker sudo dirhistory alias-tips update-plugin command-not-found history)

if [[ ! -d $PLUGIN_PATH ]]; then
  mkdir -p $PLUGIN_PATH
fi
function installSource(){
  if [[ ! -d $PLUGIN_PATH/$1 ]]; then
    git clone $2 $PLUGIN_PATH/$1 &
  fi
}


source $PLUGIN_PATH/zsh-autosuggestions/zsh-autosuggestions.zsh
source $PLUGIN_PATH/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $ZSH/oh-my-zsh.sh

eval "$(fzf --zsh)"

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
  alias shutdown="echo 'TY DEBILU'"
fi


mkdir -p /tmp/home-tmp
#env
export DOCKER_BUILDKIT=1
export EDITOR=nvim
# Use bat for man
export MANPAGER="sh -c 'col -bx | bat -l man -p'";
export MANROFFOPT="-c";
export KUBE_CONFIG_FILE=$HOME/.k3d/kubeconfig-k3s-default.yaml
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

#aliases----
#global
alias -g G='| grep'
# pipe output to less
alias -g L='| less'
# convert multiline output to single line and copy it to the system clipboard
alias -g C='| tr -d ''\n'' | xclip -selection clipboard' 
#arch
alias pacman="$su pacman"
# git
alias gsps="git stash && git pull --rebase && git stash pop"
alias gic="git clone"
alias lzg="lazygit"
alias lzd="lazydocker"
# compileDeamon
alias gocd='f(){ CompileDaemon -build="$2" -directory="$3" -include="*.rs" -include="*.html" -include="*.sh" -include="*.toml" -include="*.zig" -color=true -log-prefix=false -command="$1" -command-stop=true; }; f'
# else
find_dirs="\$(find . -type d \( -name '.cache' -o -name 'cache' -o -name '.git' -o -name 'node_modules' \) -prune -o -type d -print 2> /dev/null | fzf)"
alias vimf="nvim \$(find . -type d \( -name 'node_modules' -o -name '.cache' \) -prune -o -type f -print | fzf)"
alias cdw="cd $HOME/code && cd $find_dirs"
alias cdf="cd $find_dirs"
alias ff='f(){ find . -type d \( -name "node_modules" -o -name ".cache" \) -prune -o -type f -name $1 -print | fzf;}; f'
alias cat="bat"
alias forcoz='go build -ldflags=-compressdwarf=false -gcflags=all="-N -l"'
alias w="watch -n 0.2"
alias k="kubectl"
alias ain="ain ~/.config/global.ain"
alias expl="xdg-open"
alias rag="ranger"
alias ragcd=". ranger"
alias gocov="printCoverage"
alias code-cleanup="cc"
alias rr="rm -rf"
alias upgo='dupa=$PWD && cd ~/.update-golang && git pull && $su ~/.update-golang/update-golang.sh && cd $dupa'
alias goline='f(){ go build -gcflags="-m $1"}; f'
alias gobce="go build -gcflags=-d=ssa/check_bce/debug=1"
alias vim=nvim
alias tldrf='tldr --list | fzf --preview "tldr {1} --color=always" --preview-window=right,70% | xargs tldr'
alias fzfv='fzf | xargs nvim'
alias mult="sed -e 's/, \"/,\n\t\"/g' -e 's/{/{\n\t/g' -e 's/\}/\n}/g'"
alias gub="~/go/bin/gup"
alias dport='docker ps --format "table {{.Names}}\t{{.Ports}}"'
alias dstat='docker ps -a --format "table {{.Names}}\t{{.Status}}"'

alias backup="sudo rsync -aAXHP --info=progress2 --no-inc-recursive --numeric-ids --human-readable --stats"

# -----------------------------------------------------------------------------
alias prptmp="cd /tmp/home-tmp && mkdir gotmp; cd gotmp && echo 'package main

func main() {
	
}'>> main.go && go mod init test && code ." 
# -----------------------------------------------------------------------------


# function cc(){
#   git fetch --prune
#   branches=$(git branch -vv | grep ': gone]' | awk '{print $1}')
#
#   if [ -z $branches ]; then
#       echo "Nothing to do"
#   fi
#   echo $branches | xargs -n1 --no-run-if-empty git branch --delete --force
# }


# Arch Mirrors update
distro=$(source /etc/os-release; echo ${ID_LIKE:=$ID})
if [[ $distro == "arch" ]]; then
    alias updm-rate="sudo reflector -a 10 -c pl --sort rate --save /etc/pacman.d/mirrorlist"
    alias updm-score="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
fi


function printCoverage {
  FILE=$(mktemp)
  go test ./... -coverprofile=''${FILE}
  cat ''${FILE} | grep -Fv -e '.gen.go' -e '.pb.go' > ''${FILE}.filter
  if [ "$1" == "html" ]; then
    go tool cover -html=''${FILE}.filter
  else
    go tool cover -func=''${FILE}.filter
  fi
}

function  mans(){
    man -k . \
    | fzf -n1,2 --preview "echo {} \
    | cut -d' ' -f1 \
    | sed 's# (#.#' \
    | sed 's#)##' \
    | xargs -I% man %" --bind "enter:execute: \
      (echo {} \
      | cut -d' ' -f1 \
      | sed 's# (#.#' \
      | sed 's#)##' \
      | xargs -I% man % \
      | less -R)"
}
shrug() { echo -n "¯\_(ツ)_/¯" |tee /dev/tty| xsel -bi; }

video_to_gif() {
    # Check if input file exists
    if [ ! -f "$1" ]; then
        echo "Error: Input file '$1' not found"
        return 1
    fi
    
    base_name="${1%.*}"
    output_file="edited.${base_name}.gif"
    temp_dir=$(mktemp -d /tmp/gif_conversion.XXXXXX)
    
    temp_palette="$temp_dir/palette.png"
    
    ffmpeg -v error -i "$1" -vf fps=15,scale=320:-1:flags=lanczos,palettegen=max_colors=256 -y "$temp_palette"
    
    ffmpeg -v error -i "$1" -i "$temp_palette" \
        -filter_complex "fps=15,scale=320:-1:flags=lanczos[x];[x][1:v]paletteuse=dither=floyd_steinberg" \
        -loop 0 "$output_file"
    
    rm -rf "$temp_dir"
    
    if [ $? -eq 0 ] && [ -f "$output_file" ]; then
        echo "Successfully created: $output_file"
    else
        echo "Error: Failed to create GIF"
        return 1
    fi
}

wexec() {
    local dir=""
    local cmd=""
    local timeout="0"
    
    # Parse options with getopts
    while getopts ":t:h" opt; do
        case $opt in
            t)
                timeout="$OPTARG"
                ;;
            h)
                echo "Usage: watch_and_execute [-t|--timeout <time>] <directory> <command> [args...]"
                return 0
                ;;
            \?)
                echo "Invalid option: -$OPTARG" >&2
                return 1
                ;;
            :)
                echo "Option -$OPTARG requires an argument." >&2
                return 1
                ;;
        esac
    done
    
    # Shift past options
    shift $((OPTIND-1))
    
    # Check required arguments
    if [ $# -lt 2 ]; then
        echo "Usage: watch_and_execute [-t|--timeout <time>] <directory> <command> [args...]"
        return 1
    fi
    
    dir="$1"
    shift
    cmd="$@"
    
    # Verify directory exists
    if [ ! -d "$dir" ]; then
        echo "Error: Directory '$dir' does not exist"
        return 1
    fi
    
    # Watch directory and execute command on changes
    inotifywait --quiet --monitor --recursive \
        --event close_write \
        --format '%w%f' "$dir" |
    while read -r filename; do
        # Skip temporary files
        if [[ $filename =~ "~( |$)" ]]; then
            continue
        fi
        
        if [[ $filename =~ "4913" ]]; then
            continue
        fi
        # Get current time with milliseconds
        local timestamp=$(date +"%H:%M:%S.%3N")
        
        echo "---"
        echo "$timestamp: $filename"
        
        # Replace {file} with actual filename in command
        local modified_cmd="$cmd"
        modified_cmd="${modified_cmd//\{file\}/$filename}"
        
        # Execute command with timeout and proper shell handling
        (
            trap '' PIPE
            if ! timeout --foreground "$timeout" sh -c "$modified_cmd"; then
                local status_copy=$?
                if [ $status -eq 124 ]; then
                    echo "Command timed out after $timeout"
                else
                    echo "Command failed with exit code $status_copy"
                fi
            fi
        ) 2>&1 | while read -r line; do
            echo "$line"
        done
    done
}
tmux-window-name() {
	($TMUX_PLUGIN_MANAGER_PATH/tmux-window-name/scripts/rename_session_windows.py &> /dev/null &)
}

autoload -U add-zsh-hook
add-zsh-hook chpwd tmux-window-name

bindkey -r '^[l'
bindkey '^[l' autosuggest-accept
# bindkey '^0' autosuggest-execute

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
