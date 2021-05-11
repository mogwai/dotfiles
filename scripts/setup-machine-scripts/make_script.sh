#/bin/bash
IFS=$'\n'
mkdir -p ssh
cp ~/.ssh/id_rsa ssh
cp ~/.ssh/id_rsa.pub ssh
cp ~/.ssh/config ssh
ssh-keygen -p -f ssh/id_rsa
SSH_KEY=$(cat ssh/id_rsa)
SSH_KEY_PUB=$(cat ssh/id_rsa.pub)

python ./create_tools_script.py > install.sh

# Delete the folder we generated
rm -rf ssh
chmod +x install.sh
