# .bashrc

# User specific aliases and functions

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

export PATH=$PATH:/root/bin:/data/php/bin:/data/php/libs/vendor/bin
export TERM=xterm

## php composer
export COMPOSER_HOME=/data/php/libs
export COMPOSER_BIN_DIR=/data/php/bin

alias ls='ls --color=auto'
alias la='ls -aF --color=auto'
alias ll='ls -alF --color=auto'
alias ..='cd ..'
alias grep='grep -E'

