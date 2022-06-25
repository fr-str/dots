#!/bin/bash
set -ex
dir=$(pwd)
# find system package manager
if [ -x /usr/bin/apt-get ]; then
    # Debian/Ubuntu
    PM="apt-get -y"
elif [ -x /usr/bin/yum ]; then
    # CentOS/Fedora/RHEL
    PM="yum -y"
elif [ -x /usr/bin/pacman ]; then
    # Arch Linux
    PM="pacman --noconfirm -S"
else
    echo "Unable to find a package manager"
    exit 1
fi
# check if root
if [ "$(id -u)" != "0" ]; then
    sudo="sudo"
fi

# install stuff that I want
$sudo $PM install git zsh docker docker-compose wget
# get newest relase of btop from https://github.com/aristocratos/btop/releases
regex='^href.*\/.*\/(v[0-9]\.[0-9]\.[0-9])'
for v in $(curl https://github.com/aristocratos/btop/releases | grep releases/download); do
    echo $([[ $v =~ $regex ]])
    if [[ $v =~ $regex ]]; then
        echo "Found btop version ${BASH_REMATCH[1]}"
        echo "Downloading btop..."
        wget https://github.com/aristocratos/btop/releases/download/${BASH_REMATCH[1]}/btop-x86_64-linux-musl.tbz
        # extract btop
        echo "Extracting btop..."
        mkdir btop-folder
        tar -xvf btop-x86_64-linux-musl.tbz --directory=btop-folder
        # isntall
        echo "Installing btop..."
        cd btop-folder
        sudo make install
        cd .. && rm -rf btop-x86_64-linux-musl.tbz btop-folder
        break
    fi
done

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
# install zsh-autosuggestions and zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh/zsh-syntax-highlighting

# copy contents of cpu-scripts to $HOME/.local/bin
cp -r cpu-scripts /usr/bin  

# clone update-golang and insall go
git clone https://github.com/udhos/update-golang $HOME/.update-golang
cd $HOME/.update-golang
sudo ./update-golang.sh
cd $dir

# install CompileDeamon from https://github.com/fr-str/CompileDaemon
git clone https://github.com/fr-str/CompileDaemon $HOME/.CompileDaemon
cd $HOME/.CompileDaemon
go build
cp CompileDaemon $HOME/go/bin/CompileDaemon

# copy my zshrc to home
cd $dir
cp .zshrc $HOME/.zshrc
source $HOME/.zshrc
