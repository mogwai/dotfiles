#/bin/bash

files="bashrc bash_aliases vimrc tmux.conf gitconfig pdbrc.py gitattributes htoprc"

for i in $files; do
    mv ~/.$i ~/.$i.bak
    ln -s $(pwd)/$i ~/.$i
done


mv ~/.ssh/config ~/.ssh/config.bak
ln -s ~/dotfiles/sshconfig ~/.ssh/config
