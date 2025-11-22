# System-wide .bashrc file for interactive bash(1) shells.

# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, overwrite the one in /etc/profile)
# but only if not SUDOing and have SUDO_PS1 set; then assume smart user.
if ! [ -n "${SUDO_USER}" -a -n "${SUDO_PS1}" ]; then
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

# Commented out, don't overwrite xterm -T "title" -n "icontitle" by default.
# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
#    ;;
#*)
#    ;;
#esac

# enable bash completion in interactive shells
#if ! shopt -oq posix; then
#  if [ -f /usr/share/bash-completion/bash_completion ]; then
#    . /usr/share/bash-completion/bash_completion
#  elif [ -f /etc/bash_completion ]; then
#    . /etc/bash_completion
#  fi
#fi

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
    function command_not_found_handle {
        # check because c-n-f could've been removed in the meantime
        if [ -x /usr/lib/command-not-found ]; then
            /usr/lib/command-not-found -- "$1"
            return $?
        elif [ -x /usr/share/command-not-found/command-not-found ]; then
            /usr/share/command-not-found/command-not-found -- "$1"
            return $?
        else
            printf "%s: command not found\n" "$1" >&2
            return 127
        fi
    }
fi

export TERM=xterm-256color
export PS1="\[\033[1;48;5;15;38;5;17m\]🐧 \u \[\033[0;32m\]\[\033[1;38;5;34m\]@\h\[\033[0;32m\]\[\033[1;38;5;111m\]\w\[\033[0m\]: "

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
. "$HOME/.cargo/env"
export PATH=$PATH:$HOME/.local/bin
eval "$(uv generate-shell-completion bash)"

function ssh-eval {
    eval $(ssh-agent -s)
    ssh-add ~/.ssh/id_rsa
}

function _update_ps1() {
    PS1=$(powerline-shell $?)
}

if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi


# Environment variables
export CASTELLO_SERVER="192.168.0.52"
export DROPLET_IP="143.198.182.128"
export AWS_SERVER="ec2-3-133-114-116.us-east-2.compute.amazonaws.com"
export MAGALU_SERVER="201.54.1.61"
export HOSTNAME=$(hostname)

# aliases
if [ "$WSL_DISTRO_NAME" == "" ]; then
    alias explorer="explorer.exe"
fi


# remote connections
function connect-to-server() {
    if [ -n "$WSL_DISTRO_NAME" ]; then
        echo "OPENING VS CODE"
        # set the dir to the windows path
        cd /mnt/c/Users/mpro3
        cmd.exe /C code --remote ssh-remote+server
        echo "VS CODE"
        sleep 3
        ssh -X castello@"$CASTELLO_SERVER"
    fi
}

function connect-to-aws() {
    ssh -i "$HOME/.ssh/telemetryKeys.pem" "ubuntu@${AWS_SERVER}"
}

function copy-from-aws() {
    local args="$*"
    scp -i "$HOME/.ssh/telemetryKeys.pem" "ubuntu@${AWS_SERVER}:${args}" .
}

function connect-to-magalu() {
    ssh "debian@${MAGALU_SERVER}"
}

function copy-to-magalu() {
    local args="$*"
    scp -r ${args} "debian@${MAGALU_SERVER}:/home/debian"
}

function copy-from-magalu() {
    local args="$*"
    scp "debian@${MAGALU_SERVER}:/home/debian/${args}" .
}


# git commands
function gtck {
    local actual_key=$(git config --global user.signingKey)

    if [ "$actual_key" == "9E8404E08DA8ED75" ]; then
        echo "Setting key for matheus@castello.eng.br"
        git config --global user.email "matheus@castello.eng.br"
        git config --global user.name "Matheus Castello"
        git config --global user.signingkey '7CB84B1084E5AA77'
    else
        echo "Setting key for matheus.castello@toradex.com"
        git config --global user.email "matheus.castello@toradex.com"
        git config --global user.name "Matheus Castello"
        git config --global user.signingkey '9E8404E08DA8ED75'
    fi
}

function gtpo {
    local git_root=$(git rev-parse --show-toplevel 2>/dev/null)

    if [ -z "$git_root" ]; then
        echo "Not a git repository"
        return 1
    fi

    local branch=$(git rev-parse --abbrev-ref HEAD)

    if [ $# -eq 0 ]; then
        git push origin "$branch"
    else
        git push origin "$branch" "$@"
    fi
}

function gtbd {
    if [ $# -eq 0 ]; then
        echo "Usage: gtbd <branch-name>"
        return 1
    fi

    local branch="$1"
    git branch -d "$branch"
    git push origin --delete "$branch"
}

alias gtc="git commit -vs"
alias gts="git status"
alias gtd="git diff"
alias gta="git add"
alias gtca="git commit --amend"
alias gtr="git remote -v"
alias gtl="git log"
alias gtlog="git log --oneline"
alias gtp="git push"
alias gtrs="git checkout HEAD --"
alias gtcp="git cherry-pick"
alias gtcb="git checkout -b"
alias gtb="git checkout -b"
alias gtba="git branch -a"
alias gtrb='git rebase -i HEAD~'
alias gtrbc='git rebase --continue'
alias gtrba='git rebase --abort'
alias gtff='git fetch fork'
alias gtfo='git fetch origin'
alias gti='git init'


# bash commands
alias c='clear'
alias C='clear'
alias CLEAR='clear'
alias ls='ls -lah --color=auto -v'
alias l='/usr/bin/ls --color=auto -v'


# docker commands
alias dc="docker"
alias bosta="docker"
alias mimde="docker compose"

# start the gpg agent
gpgconf --launch gpg-agent

# get the tty device and put in the GPG_TTY
export GPG_TTY=$(tty)

# Add flutter-elinux to PATH
export PATH="/opt/flutter-elinux/bin:$PATH"
