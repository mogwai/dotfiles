# Edit bash script
function edb {
    vim ~/.bash_$1 && source ~/.bash_$1
}

# Use batcat if it exists instead of cat
function cat {
    if command -v batcat &> /dev/null
    then
        batcat $@
    else
        command cat $@
    fi
}

# Use apt-fast instead of apt if it is availiable
function apt {
    if [ -f `which apt-fast` ]; then
        apt-fast $@
    else
        apt $@
    fi
}

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

function grep {
    if [ -f `which rg` ]; then
        rg $@
    else
        grep $@
    fi
}

# ls aliases
alias l='ls -ahlF'
alias lt='ls -ahlFtr'
alias ..='cd ..'

alias cdd='cd ~/dotfiles'

# Random File from dir
alias rand='find . -type f | shuf -n 1'

#Telgram CLI
alias tg='telegram-cli -N'

# Joplin
alias j='joplin'
alias je='j edit $(j ls -l)'
alias jc='j cat $(j ls -l)'

alias po="s poweroff"
alias rb="s command reboot"

alias c='clear'
alias edba='edb aliases'
alias edbp='edb profile'
alias eb='vim ~/.bashrc && source ~/.bashrc'
alias essh='vim ~/.ssh/config'

# Nvidia
alias nv='gpustat'

# Linux
alias vrc='vim ~/.vimrc'

# Use vim with no clipboard on on ssh connection
v() {
    if [ -z ${SSH_CONNECTION+x} ]
    then
        vim $@
    else
        vim -X $@
    fi
}

alias o='xdg-open'
alias t='tmux new -s $(basename $PWD)'
alias ta='tmux a'
alias tls='tmux ls'
alias dc='docker-compose'

# Conda
alias condaa='conda activate $(basename $PWD) > /dev/null 2>&1 || condac'
alias condar='conda activate base && conda env remove -n $(basename $PWD)'
alias condals='conda env list'
alias jn='jupyter notebook'
alias jna='condaa && pip install notebook && jn'
alias clip='xclip -i -sel c'
alias wn1='watch -n 1'
alias myip='curl https://api.ipify.org'

alias hear='cvlc --play-and-exit'

# Clear ssh connection sockers
alias cssh='rm -r /tmp/ssh-*@*'

# GIT
alias gs="git status"
alias gpl="git pull"
alias gd="git diff"
alias gp="git push"

gcm() {
    git commit -am "$1"
}

# Python
alias p='python'
alias pp='vim play.py'

# Clear swap files in vim
alias vimclear='rm -r ~/.vim/swap/*.swp'

# Search History for commands matching the expression

fh() {
    history | awk '{$1=""; print substr($0,2)}'| rg $1
}

#fzf
alias gb='git branch | fzf | xargs git checkout'
alias gba='git branch -a | fzf | xargs git checkout'

rmnodem() {
    for i in $(find . -depth -name *node_modules* | tac); do rm -rf $i; done
}

# Prevents vim from opening files that don't exist without
# the --new flag
vim() {
    # LOAD NODE! For Coc-vim
    load_nvm
    local args=("$@")
    local new=0

    # Check for `--new'.
    # for ((i = 0; i < ${#args[@]}; ++i)); do
    #     if [[ ${args[$i]} = --new ]]; then
    #         new=1
    #         unset args[$i]   # Don't pass `--new' to vim.
    #     fi
    # done

    # if ! (( new )); then
    #     for file in "${args[@]}"; do
    #         [[ $file = -* ]] && continue   # Ignore options.

    #         if ! [[ -e $file ]]; then
    #             printf '%s: cannot access %s: No such file or directory\n' "$FUNCNAME" "$file" >&2
    #             return 1
    #         fi
    #     done
    # fi

    # Use `command' to invoke the vim binary rather than this function.
    command "$FUNCNAME" "${args[@]}"
}

convertnb() {
    jupyter nbconvert --to script $1 --stdout
}

venv() {
    if [[ -f .venv/bin/activate ]]; then
       # There is a venv created here
       source .venv/bin/activate
    else
        python -m venv .venv --prompt $(basename $PWD)
        source .venv/bin/activate
        pip install --upgrade pip >> /dev/null
        # Copy base venv
        pip install wheel pip setuptools pdbpp >> /dev/null
        # if [[ -f ~/.venv/bin/activate ]]; then
        #     cp -r ~/.venv/lib .venv/
        # fi
    fi
}

alias venvr='deactivate && rm -rf .venv'

function condac {
    conda create -y -n $(basename $PWD) python=3.8 > /dev/null
    conda activate $(basename $PWD)
    pip install jedi black isort pdbpp > /dev/null
    conda install -c tartansandal conda-bash-completion -y
}

battery() {
    upower -i /org/freedesktop/UPower/devices/battery_cw2015_battery | grep percent | awk '{print $2}'
}

##### AWS #####

# List EC2 Instances
ec2ls(){
    instances=`aws ec2 describe-instances | jq -r '.Reservations[].Instances[0] | select(.State.Name=="running") | .Tags[0].Value | split("|")[0]'`
    for i in $instances
    do
        mem=$(ssh $i nvidia-smi | grep -o [0-9]+MiB\ /\ [0-9]+MiB)
        echo $i $mem
    done
}

# Start EC2 Instance by name
ec2start() {
    if [ -n "$1" ]; then
        id=`aws ec2 describe-instances | jq -r '.Reservations[].Instances[0] | select(.Tags[0].Value != null) | select(.Tags[0].Value | test("'$1'")).InstanceId'`
        echo Starting $id
        aws ec2 start-instances --instance-id $id > /dev/null && ssh $1
    fi
}
complete -o bashdefault -o default -F _fzf_host_completion ec2start

# Kill Distractions
kd(){
    bash ~/dotfiles/scripts/killdistractions.sh
}

# Wifi Toggle
wf(){
    bash ~/dotfiles/scripts/togglewifi.sh
}

alias shire="nmcli c up _shire &"
alias three="nmcli c up Three_000325 &"
alias _b="nmcli c up _b &"

# Toggles bluetooth
bt(){
    bash ~/dotfiles/scripts/togglebluetooth.sh
}

D=~/desktop

hoggpu(){
    python ~/dotfiles/scripts/hoggpu.py $1
}

# Sonantic
alias train='sonctl train'
export TTS="$HOME/sonantic/src/sonantic/tts"
alias tts='cd $TTS && t &> /dev/null'

# Use sudo if we aren't root when we need to
function s {
    if [ `which sudo` ]; then
        sudo $@
    else
        $@
    fi
}
