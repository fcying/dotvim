# config.nu
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu

# https://www.nushell.sh/book/coloring_and_theming.html
# https://github.com/nushell/nu_scripts/tree/main/themes
use ($nu.default-config-dir | path join "solarized-light.nu")
solarized-light set color_config

$env.config.show_banner = false

$env.config = (
    $env.config | upsert keybindings (
        $env.config.keybindings
        | append {
            name: "fzf file"
            modifier: control
            keycode: char_t
            mode: [emacs, vi_normal, vi_insert]
            event: {
                send: executehostcommand
                cmd: "commandline edit --replace (fzf --reverse --height 40%)"
            }
        }
    )
)

# https://github.com/nushell/nushell/issues/8214 Conditional source
if (which atuin | is-not-empty) {
    source (if (($nu.default-config-dir | path join "atuin.nu") | path expand | path exists) {($nu.default-config-dir | path join "atuin.nu")} else {"empty.nu"})
}

source ($nu.default-config-dir | path join "zlua.nu")

alias vim = nvim
alias z = _zlua
alias zb = _zlua -b
alias zi = _zlua -i

alias ll = ls -la

alias gst = git status
alias gaa = git add --all
alias gb = git branch
alias gba = git branch -a
alias gbd = git branch -d
alias gbD = git branch -D
alias gbr = git branch --remote
alias gca = git commit -v -a
alias gca! = git commit -v -a --amend
alias gcam = git commit -a -m
alias gcb = git checkout -b
alias gclean = git clean -fd
alias gco = git checkout
alias gcp = git cherry-pick
alias gd = git diff
alias gf = git fetch
alias gfa = git fetch --all --prune
alias gfo = git fetch origin
alias gp = git push

def git_analyze [] {
    git filter-repo --analyze --force
}

def grmh [key] {
    git filter-branch --force --index-filter "git rm --cached --ignore-unmatch $key" --prune-empty --tag-name-filter cat -- --all
}

def grfc [] {
    git reflog expire --expire=now --all
}
