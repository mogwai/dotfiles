export EDITOR=vim

# Edit bash script
function edb {
    vim ~/.bash_$1 && source ~/.bash_$1 
}

# some more ls aliases
alias l='ls -alF'
alias ..='cd ..'

#Telgram CLI
alias tg='telegram-cli -N'

alias c='clear'
alias edba='edb aliases'
alias edbp='edb profile'
alias eb='vim ~/.bashrc && source ~/.bashrc'
alias essh='vim ~/.ssh/config'

alias vf='vim $(fzf)'
alias vrc='vim ~/.vimrc'
alias v='vim'

alias o='xdg-open '
alias t='tmux'
alias dc='docker-compose'
alias condaa='conda activate $(basename $PWD) > /dev/null 2>&1 || condac'
alias condar='conda activate base && conda env remove -n $(basename $PWD)'
alias jn='jupyter notebook'
alias jna='condaa && pip install notebook && jn'
alias clip='xclip -i -sel c'
alias terminal='gnome-terminal'
alias kc='kubectl'
alias wn1='watch -n 1'
alias myip='curl https://api.ipify.org'
alias grep='rg'

# Clear ssh connection sockers
alias cssh='rm -r /tmp/ssh-*'

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
    if [[ ! -f ./.venv/bin/activate ]]; then
        echo Creating Virtual Environment $(basename $PWD)
        python -m venv .venv --prompt $(basename $PWD)
    fi
    source .venv/bin/activate
}

function condac {
    conda create -y -n $(basename $PWD) python=3.8 > /dev/null
    conda activate $(basename $PWD)
    pip install jedi black isort pdbpp > /dev/null
}
