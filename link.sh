#/bin/bash

files="bashrc bash_profile bash_aliases vimrc tmux.conf gitconfig pdbrc.py gitattributes"

for i in $files; do
    mv ~/.$i ~/.$i.bak
    ln -s $(pwd)/$i ~/.$i
done


mv ~/.ssh/config ~/.ssh/config.bak
ln -s $(pwd)/sshconfig ~/.ssh/config

