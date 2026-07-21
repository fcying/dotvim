# Zimfw bootstrap and plugin initialization.
ZIM_CONFIG_FILE="$MY_CONFIG_DIR/zimrc"
ZIM_HOME=${ZIM_HOME:-"${XDG_CACHE_HOME:-$HOME/.cache}/zim"}

if [[ ! -e "$ZIM_HOME/zimfw.zsh" ]]; then
    download "$ZIM_HOME/zimfw.zsh" "${CDN}https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh"
fi

if [[ ! "$ZIM_HOME/init.zsh" -nt "$ZIM_CONFIG_FILE" ]]; then
    source "$ZIM_HOME/zimfw.zsh" init
fi
source "$ZIM_HOME/init.zsh"

function zimfw_completion_config() {
    # Local additions to the Zim completion module.
    setopt PATH_DIRS
    setopt AUTO_MENU
    setopt AUTO_LIST
    setopt AUTO_PARAM_SLASH

    zmodload -i zsh/complist
    bindkey -M menuselect '^n' expand-or-complete
    bindkey -M menuselect '^p' reverse-menu-complete

    zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
    zstyle ':completion:*:-tilde-:*' group-order named-directories path-directories users expand
    zstyle ':completion:*:default' list-prompt '%S%M matches%s'

    zstyle ':completion:*' completer _complete _match _approximate
    zstyle ':completion:*:match:*' original only
    zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'

    zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}

    zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
    zstyle ':completion:*:*:kill:*' menu yes select
    zstyle ':completion:*:*:kill:*' force-list always

    zstyle ':completion:*:(ssh|scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
    zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
    zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr
    zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
    zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
    zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'
}

zimfw_completion_config

function _zimfw_run_post_init() {
    zle -F "$1"
    exec {1}<&-
    zsh_post_init
    unfunction _zimfw_run_post_init
}

function _zimfw_schedule_post_init() {
    add-zsh-hook -d precmd _zimfw_schedule_post_init
    exec {fd}< <(command sleep 0.1; builtin print)
    command true
    zle -F "$fd" _zimfw_run_post_init
    unfunction _zimfw_schedule_post_init
}

# Run the remaining local initialization after the first prompt is available.
autoload -Uz add-zsh-hook
add-zsh-hook precmd _zimfw_schedule_post_init

function plugin_update() {
    zimfw upgrade
    zimfw update
}

function plugin_post_init() {
}
