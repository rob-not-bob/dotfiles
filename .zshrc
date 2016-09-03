setopt AUTO_CD				# no need to type cd dir, instead just type the dir
setopt MULTIOS				# Pipe to multiple outputs
setopt NO_BEEP				# Disable any beeping
setopt GLOB_COMPLETE		# If we have a glob this will expand it
setopt NO_CASE_GLOB			# Case insensitive Globbing
setopt NUMERIC_GLOB_SORT	# Sort glob results numerically
setopt EXTENDED_GLOB		# Expand the globbing
setopt RC_EXPAND_PARAM		# Expand arrays in substitution
bindkey -v					# enable vim mode
export KEYTIMEOUT=1			# reduce lag between <ESC> and normal mode to 0.1s


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
alias ev='vim ~/.vimrc'

alias grep='grep --color=auto'

alias lsr='ls -l ./*(mh-1)'

alias c="xclip -selection clipboard"
alias p="xclip -o -selection clipboard"

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
insert_sudo() { 
	zle beginning-of-line
	BUFFER="sudo $BUFFER";
	zle end-of-line
}
zle -N insert-sudo insert_sudo
bindkey "^[s" insert-sudo

PS1='%C → '

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

function cdl() {
	cd "$@" && ls;
}

source /usr/share/doc/pkgfile/command-not-found.zsh

# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored
zstyle ':completion:*' glob set
zstyle :compinstall filename '/home/ace/.zshrc'

autoload -Uz compinit
compinit

# End of lines added by compinstall
