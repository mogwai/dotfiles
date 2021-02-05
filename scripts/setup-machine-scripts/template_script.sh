# /bin/bash

# Basic Setup for a terminal in linux

# Description
# ===========
# A tool to setup bare bones for machine being worked on

set -e

# Use sudo if we aren't root when we need to
function s {
    if [ `which sudo` ]; then
        $@
    else
        $@
    fi
}

# Prevent install dialogues
export DEBIAN_FRONTEND=noninteractive
mkdir -p ~/.ssh
echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config
s ln -fs /usr/share/zoneinfo/Europe/London /etc/localtime

s apt update
s apt install apt-transport-https software-properties-common -y --fix-missing
s add-apt-repository ppa:apt-fast/stable -y
s apt install -y apt-fast

# Setup apt-fast
echo debconf apt-fast/maxdownloads string 20 | debconf-set-selections
echo debconf apt-fast/dlflag boolean false | debconf-set-selections
echo debconf apt-fast/aptmanager string apt | debconf-set-selections

s apt-fast install -y git curl fzf vim-gtk ncdu htop ripgrep build-essential tmux python3-pip python3.8 python3-apt

s update-alternatives --install /usr/bin/python python /usr/bin/python3.8 0

# Install Node
curl https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

nvm install stable
nvm use stable

# Vim Setup
mkdir -p ~/.vim/undo
mkdir -p ~/.vim/swap
mkdir -p ~/.config/coc

curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +'PlugInstall' +qall
echo y # Confirm continue

# Coc Extensions
extensions='coc-python coc-json coc-yaml'
mkdir -p ~/.config/coc/extensions
cd  ~/.config/coc/extensions

if [ ! -f package.json ]
then
  echo '{"dependencies":{}}'> package.json
fi

npm i $extensions --global-stylus --ignore-scripts --no-bin-links --no-package-lock --only=prod

# Back to home directory
cd

# SSH Keys
SSH_KEY="'$SSH_KEY'"
SSH_KEY_PUB="'$SSH_KEY_PUB'"
echo $SSH_KEY
if [ $SSH_KEY != "\'\'" ]; then
  read -n 1 -p "Install SSH keys? (y/n): " input
  echo \n

  if [[ $input == "Y" || $input == "y" ]]; then
    mkdir -p ~/.ssh
    printf '%s' "$SSH_KEY" >> ~/.ssh/id_rsa
    printf '%s' "$SSH_KEY_PUB" >> ~/.ssh/id_rsa.pub
    chmod 0600 ~/.ssh/id_rsa
  fi
fi

# Install dotfiles
git clone git@github.com:mogwai/dotfiles
cd dotfiles
bash link.sh
