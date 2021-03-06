# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Get dotfiles updates
cwd=$PWD
cd ~/dotfiles

# Hides output completely of the command
( git pull > /dev/null 2>&1 & )
( command vim -e +'PlugInstall --sync' +qa > /dev/null  & )
( command vim -e +'PlugClean --sync' +qa > /dev/null  & )
cd $cwd

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=
HISTFILESIZE=
HISTTIMEFORMAT="%d/%m/%y %T "

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
# force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

if [ "$color_prompt" = yes ]; then
    PS1="${debian_chroot:+($debian_chroot)}\[\033[01;34m\]\u@\h:\W\[\033[00;32m\]\$(git_branch)\[\033[00m\] \$ "

else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi


# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

NVM_DIR="$HOME/.nvm"

# Skip adding binaries if there is no node version installed yet
if [ -d $NVM_DIR/versions/node ]; then
  NODE_GLOBALS=(`find $NVM_DIR/versions/node -maxdepth 3 \( -type l -o -type f \) -wholename '*/bin/*' | xargs -n1 basename | sort | uniq`)
fi

NODE_GLOBALS+=("nvm")

load_nvm () {
  # Unset placeholder functions
  for cmd in "${NODE_GLOBALS[@]}"; do unset -f ${cmd} &>/dev/null; done

  # Load NVM
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

  # (Optional) Set the version of node to use from ~/.nvmrc if available
  nvm use 2> /dev/null 1>&2 || true

  # Do not reload nvm again
  export NVM_LOADED=1
}

for cmd in "${NODE_GLOBALS[@]}"; do
  # Skip defining the function if the binary is already in the PATH
  if ! which ${cmd} &>/dev/null; then
    eval "${cmd}() { unset -f ${cmd} &>/dev/null; [ -z \${NVM_LOADED+x} ] && load_nvm; ${cmd} \$@; }"
  fi
done

kubectl () {
    command kubectl $*
    if [[ -z $KUBECTL_COMPLETE ]]
    then
        source <(command kubectl completion bash)
        KUBECTL_COMPLETE=1
		complete -F __start_kubectl k
    fi
}

alias k=kubectl

# HELM Lazy load

helm () {
    command helm $*
    if [[ -z $_HELM_COMPLETE ]]
    then
        source <(command helm completion bash)
        _HELM_COMPLETE=1
    fi
}

# Setup fzf bash
if [[ -f ~/.fzf.bash ]]
then
  . ~/.fzf.bash
fi

if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs'
  # export FZF_DEFAULT_OPTS='-m --height 50% --preview "batcat --style=numbers --color=always --line-range :500 {}"'
fi

# GoLang
# export GOROOT=/home/$USER/.go
# export PATH=$GOROOT/bin:$PATH
# export GOPATH=/home/$USER/go
# export PATH=$GOPATH/bin:$PATH

# Helm
# source <(helm completion bash)

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi


pip () {
    command pip $*
    if [[ -z $_PIP_COMPLETE ]]
    then
        source <(command pip completion --bash)
        _PIP_COMPLETE=1
    fi
}

docker () {
    command docker $*
    if [[ -z `service docker status` ]] || [[ -z `service containerd status` ]]
    then
        sudo systemctl start docker
        sudo systemctl start containerd
    fi
}

# Save bash history
# After each command, save and reload history
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

if type gh &> /dev/null; then
    source <(gh completion -s bash)
fi

export GPG_TTY=$(tty)

# SSH Agent
# Checks if there is a connection already before creating a
# new agent and auth sock
if [ -z ${SSH_CONNECTION+x} ]; then
  if [ ! -S ~/.ssh/ssh_auth_sock ]; then
    eval `ssh-agent` > /dev/null
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
  fi
  export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
  ssh-add -l > /dev/null || ssh-add > /dev/null
fi

# Activate conda environment if there is one
basename=$(basename $PWD)
if [[ -f .venv/bin/activate ]]; then
    source .venv/bin/activate
elif [[ -d ~/miniconda3/envs/$basename ]]; then
    conda activate $basename > /dev/null
fi


# If we want powerline in the terminal
# if [ -f ~/.vim/plugged/powerline/powerline/bindings/bash/powerline.sh ]; then
#     source ~/.vim/plugged/powerline/powerline/bindings/bash/powerline.sh
# fi

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Create directory for tmux
export TMUX_TMPDIR=~/.tmux/tmp
mkdir -p $TMUX_TMPDIR

# RUST
if [[ -f "$HOME/.carge/env" ]]; then
  . "$HOME/.cargo/env"
fi


export DISABLE_SLACK_LOGGING=true
