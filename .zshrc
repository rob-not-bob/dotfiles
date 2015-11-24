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
