#!/usr/bin/env bash

# Configure PS1 with flashing username and red path for root login
if [[ $EUID -ne 0 ]]; then
    export PS1='\[\033[0;36m\]\u@\h\[\033[0m\]:\[\033[0;37m\]\w\[\033[0m\]$ '
else
    export PS1='\[\033[0;5m\]\u@\h\[\033[0m\]:\[\033[0;31m\]\w\[\033[0m\]# '
fi

# Setup history search ability (only bind when a tty is present)
if [ -t 1 ]; then
    bind '"\e[A":history-search-backward'
    bind '"\e[B":history-search-forward'
fi
