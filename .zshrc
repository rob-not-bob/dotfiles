# no need to type cd dir, instead just type the dir
setopt AUTO_CD

# Pipe to multiple outputs
setopt MULTIOS

# Wait before doing something to delete everything
setopt RM_STAR_WAIT

# Disable any beeping
setopt NO_BEEP

# If we have a glob this will expand it
setopt GLOB_COMPLETE
# Case insensitive Globbing
setopt NO_CASE_GLOB
# Sort glob results numerically
setopt NUMERIC_GLOB_SORT
# Expand the globbing
setopt EXTENDED_GLOB

# Expand arrays in substitution
setopt RC_EXPAND_PARAM

# enable vim mode
bindkey -v
export KEYTIMEOUT=1 # reduce lag between <ESC> and normal mode to 0.1s


# ALIASES

alias ls='ls --color'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../../'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'

alias sz='source ~/.zshrc'
alias ez='vim ~/.zshrc'

alias grep='grep --color=auto'

alias lsr='ls -l ./*(mh-1)'

HISTFILE=~/.history

SAVEHIST=10000
HISTSIZE=10000

setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

# Alt-S inserts sudo at start of line
insert_sudo() { zle beginning-of-line; zle -U "sudo " }
zle -N insert-sudo insert_sudo
bindkey "^[s" insert-sudo

PS1='%C → '

# function to switch and save the current path
function cd() {
	builtin cd "$@";
	echo "$PWD" > /tmp/.cwd;
}

export cd
alias cwd='cd "$(cat /tmp/.cwd &>/dev/null)"'
cwd

# Color man pages
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}

export PATH="$JAVA_HOME/bin:$PATH"

# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored
zstyle ':completion:*' glob set
zstyle :compinstall filename '/home/ace/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
