export EDITOR=vim

# Edit bash script
function edb {
    vim ~/.bash_$1 --sync && source ~/.bash_$1 
}

alias edba='edb aliases'
alias edbp='edb profile'
alias eb='vim ~/.bashrc --sync && source ~/.bashrc'
alias essh='vim ~/.ssh/config'

alias vf='vim $(fzf)'
alias vrc='vim ~/.vimrc'
alias v='vim'

alias o='xdg-open '
alias t='konsole'
alias dc='docker-compose'
alias condac='conda create -y -n $(basename $PWD) python=3.7 > /dev/null && conda activate $(basename $PWD)'
alias condaa='conda activate $(basename $PWD) > /dev/null 2>&1 || condac'
alias condar='conda activate base && conda env remove -n $(basename $PWD)'
alias jn='jupyter notebook'
alias jna='condaa && pip install notebook && jn'
alias clip='xclip -i -sel c'
alias terminal='gnome-terminal'
alias kc='kubectl'
alias wn1='watch -n 1'

alias grep='rg'

# Search History for commands matching the expression

function fh {
    history | awk '{$1=""; print substr($0,2)}'| rg $1   
}


#fzf
alias gb='git branch | fzf | xargs git checkout'
alias gba='git branch -a | fzf | xargs git checkout'

function rmnodem() {
				for i in $(find . -depth -name *node_modules* | tac); do rm -rf $i; done
}

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
