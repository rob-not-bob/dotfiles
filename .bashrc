
set -o vi
source .aliases

git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

PS1="\[[\e[31m\u\e[34m@\e[32m\h \e[35m\w\e[m]\e[33m\$(git_branch)\]\n\[\e[36m\]\$\[\e[m\] "


###-tns-completion-start-###
if [ -f /Users/rcallen/.tnsrc ]; then 
    source /Users/rcallen/.tnsrc 
fi
###-tns-completion-end-###