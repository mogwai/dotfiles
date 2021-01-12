# /bin/bash

# Basic Tools for terminal interaction Debian Based


# Description
# ===========
# A tool to setup bare bones for machine being worked on
# Includes:
# - ssh keys
# - bash aliases
# - ssh config
# - bashrc
# - rg
# - fzf install 
# - git
# - vimrc
# - Install vim plugins

# Not done yet

# Syncthing
# preload (Cache programs in ram)
# kubectl helm
# htop 
# curl 


set -e

HAS_SUDO=$(which sudo > /dev/null &&echo 1|| echo 0)

# Use sudo if we aren't root
function s {
    if [[ "$HAS_SUDO" ]]; then
        $@
    else
        sudo $@
    fi
}

# Prevent install dialogues
export DEBIAN_FRONTEND=noninteractive
ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
s apt update --fix-missing
s apt install git curl fzf vim-gtk pigz gpg ncdu htop -y

# Add the "stable" channel to your APT sources:
echo "deb https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
The candidate channel is updated with release candidate builds, usually every second Tuesday of the month. These predate the corresponding stable builds by about three weeks.

# Add the release PGP keys:
curl -s https://syncthing.net/release-key.txt | sudo apt-key add -

# Increase preference of Syncthing's packages ("pinning")
printf "Package: *\nPin: origin apt.syncthing.net\nPin-Priority: 990\n" | sudo tee /etc/apt/preferences.d/syncthing

# Update and install syncthing:
sudo apt-get update
sudo apt-get install syncthing

# Install ripgrep
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb
s dpkg -i ripgrep_11.0.2_amd64.deb

# Install Node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

nvm install stable
nvm use stable

sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2 curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

# Python

read -n 1 -p "Install Conda? (y/n): " input

if [[ $input == "Y" || $input == "y" ]]; then 
    curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh >> miniconda.sh
    bash miniconda.sh -b
    eval "$(~/miniconda3/bin/conda shell.bash hook)"
    conda init
    conda install jedi autopep8 -y
else
    s apt install python
fi


# Vim Setup
mkdir -p ~/.vim/undo
mkdir -p ~/.config/coc

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl -L "https://cloud.baz.codes/s/mYxEMz2ifR6D5dQ/download?path=%2F&files=vimrc&downloadStartSecret=ue03mxcwy0d" >> ~/.vimrc 
vim +'PlugInstall' +qall
echo y # Confirm continueA

# Coc Extensions
extensions='coc-python coc-json coc-yaml'
mkdir -p ~/.config/coc/extensions
cd  ~/.config/coc/extensions

if [ ! -f package.json ]
then
  echo '{"dependencies":{}}'> package.json
fi

npm i $extensions --global-stylus --ignore-scripts --no-bin-links --no-package-lock --only=prod
cd

# SSH Keys
read -n 1 -p "Install SSH keys? (y/n): " input
echo \n

if [[ $input == "Y" || $input == "y" ]]; then
    mkdir -p ~/.ssh
    SSH_KEY="'$SSH_KEY'"
    SSH_KEY_PUB="'$SSH_KEY_PUB'"
    printf '%s' "$SSH_KEY" >> ~/.ssh/id_rsa
    printf '%s' "$SSH_KEY_PUB" >> ~/.ssh/id_rsa.pub
    chmod 0600 ~/.ssh/id_rsa
fi

# bash_aliases
# bashrc
# bash_profile
# ssh/config
# tmux config
