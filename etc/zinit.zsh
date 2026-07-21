# Zinit bootstrap and plugin declarations.
ZINIT_HOME=$HOME/.zinit
if [ ! -d "$ZINIT_HOME/bin/.git" ]; then
    zinit_inited="true"
    mkdir -p $ZINIT_HOME/bin
    git clone --depth 1 "${CDN}https://github.com/zdharma-continuum/zinit.git" "$ZINIT_HOME"/bin
fi
declare -A ZINIT
ZINIT[NO_ALIASES]=1
source "${ZINIT_HOME}/bin/zinit.zsh"

function plugin_update() {
    zinit self-update >/dev/null 2>&1
    zinit update --all
    zinit compile --all
}

function plugin_post_init() {
    source "$MY_CONFIG_DIR/zsh_config.zsh"
    if [ -n "$zinit_inited" ]; then
        zinit compile --all
    fi
}

#zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-autosuggestions
bindkey '^f' autosuggest-accept

zinit ice wait'0' lucid; zinit light changyuheng/fz
FZ_HISTORY_CD_CMD=_zlua
zinit ice wait'0' lucid; zinit light zsh-users/zsh-history-substring-search
bindkey -M emacs '^p' history-substring-search-up
bindkey -M emacs '^n' history-substring-search-down
zinit ice wait'0' lucid atinit'zpcompinit; zpcdreplay'; zinit light zsh-users/zsh-syntax-highlighting
zinit ice wait'1' blockf lucid atload'zsh_post_init'
zinit light zsh-users/zsh-completions
