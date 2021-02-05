#/bin/bash
SSH_KEY=$(cat ~/.ssh/id_rsa)
SSH_KEY_PUB=$(cat ~/.ssh/id_rsa.pub)
python ./create_tools_script.py > install.sh
chmod +x install.sh
