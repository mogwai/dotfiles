
# Edit bash script
function edb {
    vim ~/.bash_$1 && source ~/.bash_$1
}

function apt {
    if [ -f `which apt-fast` ]; then
        apt-fast $@
    else
        apt $@
    fi
}

# ls aliases
alias l='ls -ahlF'
alias lt='ls -ahlFtr'
alias ..='cd ..'

# Random File from dir
alias rand='find . -type f | shuf -n 1'


#Telgram CLI
alias tg='telegram-cli -N'

alias c='clear'
alias edba='edb aliases'
alias edbp='edb profile'
alias eb='vim ~/.bashrc && source ~/.bashrc'
alias essh='vim ~/.ssh/config'

# Nvidia
alias nv='nvidia-smi'

alias vrc='vim ~/.vimrc'
alias v='vim'

alias o='xdg-open'
alias t='tmux new -s $(basename $PWD)'
alias dc='docker-compose'

# Conda
alias condaa='conda activate $(basename $PWD) > /dev/null 2>&1 || condac'
alias condar='conda activate base && conda env remove -n $(basename $PWD)'
alias condals='conda env list'
alias jn='jupyter notebook'
alias jna='condaa && pip install notebook && jn'
alias clip='xclip -i -sel c'
alias terminal='gnome-terminal'
alias kc='kubectl'
alias wn1='watch -n 1'
alias myip='curl https://api.ipify.org'
alias grep='rg'
alias hear='cvlc --play-and-exit'

# Clear ssh connection sockers
alias cssh='rm -r /tmp/ssh-*@*'

# GIT
alias gs="git status"

# Python
alias p='python'

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
    load_nvm
    local args=("$@")
    local new=0

    # Check for `--new'.
    for ((i = 0; i < ${#args[@]}; ++i)); do
        if [[ ${args[$i]} = --new ]]; then
            new=1
            unset args[$i]   # Don't pass `--new' to vim.
        fi
    done

    if ! (( new )); then
        for file in "${args[@]}"; do
            [[ $file = -* ]] && continue   # Ignore options.

            if ! [[ -e $file ]]; then
                printf '%s: cannot access %s: No such file or directory\n' "$FUNCNAME" "$file" >&2
                return 1
            fi
        done
    fi

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
        if [[ -f ~/.venv/bin/activate ]]; then
            cp -r ~/.venv/lib .venv/
        fi
    fi
}

function condac {
    conda create -y -n $(basename $PWD) python=3.8 > /dev/null
    conda activate $(basename $PWD)
    pip install jedi black isort pdbpp > /dev/null
    conda install -c tartansandal conda-bash-completion -y
}

battery() {
    upower -i /org/freedesktop/UPower/devices/battery_cw2015_battery | grep percent | awk '{print $2}'
}

# AWS
ec2ls(){
    aws ec2 describe-instances | jq -r '.Reservations[].Instances[0] | {id: .InstanceId, state:.State.Name, name: .Tag}'
}

ec2start() {
    id=`aws ec2 describe-instances | jq -r '.Reservations[].Instances[0] | {id: .InstanceId, state:.State.Name, name: .Tags[0].Value, dns: .PublicDnsName } | select(.name|test("'$1'")).id'`
    aws ec2 start-instances --instance-id $id
}
