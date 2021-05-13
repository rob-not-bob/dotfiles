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

export LSCOLORS="ExFxdxbxCxBxDxxx"
alias ls='ls -G'
alias ll='ls -lha'

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

alias bc='bc -l -q'

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
#insert_sudo() { zle beginning-of-line; BUFFER="sudo $BUFFER"; zle end-of-line; }
#zle -N insert-sudo insert_sudo
#bindkey "\es" insert-sudo

source ~/.aliases

bindkey "^K" history-incremental-pattern-search-backward
bindkey "^J" history-incremental-pattern-search-forward

git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

autoload -Uz vcs_info
precmd() { vcs_info }

zstyle ':vcs_info:git:*' formats '(%b)'

setopt PROMPT_SUBST
PROMPT='[%F{red}%n%F{blue}@%F{green}%m %F{magenta}%~%f]%F{yellow} ${vcs_info_msg_0_}%f
→ '

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

# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored
zstyle ':completion:*' glob set
zstyle :compinstall filename '/home/ace/.zshrc'

autoload -Uz compinit
compinit

# End of lines added by compinstall

# Tells vim mode status at right end of prompt
#function zle-line-init zle-keymap-select {
    #RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
    #RPS2=$RPS1
    #zle reset-prompt
#}
#zle -N zle-line-init
#zle -N zle-keymap-select

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
export PATH="/usr/local/opt/qt/bin:$PATH"
export PATH="${HOME}/miniconda3/bin:$PATH"
export PATH="${HOME}/bin:$PATH"

###-tns-completion-start-###
if [ -f /Users/rcallen/.tnsrc ]; then 
    source /Users/rcallen/.tnsrc 
fi
# . ~/.fastlane/completions/completion.sh
###-tns-completion-end-###

# brew CLI commands auto completion 
# if type brew &>/dev/null; then
#   FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
# 
#   autoload -Uz compinit
#   compinit
# fi

# if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

