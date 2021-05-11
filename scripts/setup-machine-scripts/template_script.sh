# /bin/bash

# Basic Setup for a terminal in linux

# Description
# ===========
# A tool to setup bare bones for machine being worked on
current_dir=$(pwd)
cd dotfiles
bash link.sh

set -e

# Use sudo if we aren't root when we need to
function s {
    if [ `which sudo` ]; then
        sudo $@
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
s apt install apt-transport-https software-properties-common python3-apt -y --fix-missing
s add-apt-repository ppa:apt-fast/stable -y
s apt install -y apt-fast

# Setup apt-fast
s echo debconf apt-fast/maxdownloads string 20 | s debconf-set-selections
s echo debconf apt-fast/dlflag boolean false | s debconf-set-selections
s echo debconf apt-fast/aptmanager string apt | s debconf-set-selections

s apt-fast install -y git curl vim-gtk ncdu htop build-essential tmux python3-pip python3.8 python3-apt python3-venv

# FZF
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --key-bindings --completion

# Ripgrep

curl -LO https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep_12.1.1_amd64.deb
s dpkg -i ripgrep_12.1.1_amd64.deb
rm ripgrep_12.1.1_amd64.deb

# This might break Ubuntu < 19
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

# Coc Extensions
extensions='coc-jedi coc-json coc-yaml'
mkdir -p ~/.config/coc/extensions
cd  ~/.config/coc/extensions

if [ ! -f package.json ]
then
  echo '{"dependencies":{}}'> package.json
fi

npm i $extensions --global-stylus --ignore-scripts --no-bin-links --no-package-lock --only=prod

cd
source ~/dotfiles/bash_aliases
venv
pip install powerline-status

cd $current_dir

# Install Delta for Git diffs

curl -OL https://github.com/dandavison/delta/releases/download/0.7.1/git-delta_0.7.1_amd64.deb
s dpkg -i git-delta_0.7.1_amd64.deb
rm git-delta_0.7.1_amd64.deb
