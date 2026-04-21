My NEOVIM config.

#### Install
```
git clone https://github.com/fcying/dotvim.git ~/.config/nvim
or
wget https://github.com/fcying/dotvim/releases/download/nvim_config/nvim_config_with_vendor.txz
tar xJf nvim_config_with_vendor.txz
mv nvim ~/.config/
```

first start will auto install `lazy.nvim` and missing plugins.

#### nvim_config_with_vendor.txz
portable package built by GitHub Actions.

includes `rg` `ctags` `clangd` `lua-language-server`

#### runtime dir
runtime data is stored in `.run/` under this repo.

includes:
`plugins` `mason` `shada` `undo` `cache` `log`

#### etc folder
other tools config.  e.g.  
`zsh` `ctags` `rg` `tmux` `tig`...

#### user config
`<leader>evl`  
modify user config.  
`~/.vimrc.local`

#### project config
`<leader>evp`  
modify project config.  
project config file name: `.nvim.lua` or `.pvimrc`.  
it is searched by root marker (`.root` `.git` `.repo` `.svn`).  
if not found, create `.nvim.lua` in root dir.  
autoreload project config after save this file.

#### config var
config var, modify it in `user config` or `project config`.  

* `Option`  
    Option for fuzzyfind and generate tags, default:
```
Option.dir = { ".root", ".svn", ".git", ".repo", ".ccls-cache", ".cache", ".ccache", ".run", "CMakeFiles" }
Option.file = { "*.sw?", "~$*", "*.bak", "*.exe", "*.o", "*.so", "*.py[co]", "tags" }
Option.mru = { "*.so", "*.exe", "*.py[co]", "*.sw?", "~$*", "*.bak", "*.tmp", "*.dll" }
Option.rg = { "--max-columns=300", "--iglob=!obj", "--iglob=!out" }
Option.gencconf_default_option = {
    ["*"] = { "-ferror-limit=0" },
    c = { "gcc", "-c", "-std=c11" },
    cpp = { "g++", "-c", "-std=c++14" },
}
Option.lsp = {}
```

* `g:colorscheme`  
    e.g.  
    ```
    let g:colorscheme='solarized'
    ```
* `g:background`  
    e.g.  
    ```
    let g:background='light'
    ```

* `g:pylsp_jedi_environment`
    default `exepath('python3')`

* `g:complete_engine`
    `blink` or `cmp`, default `blink`

#### Shortcuts
default `<leader>` is `<space>`
| Shortcut            | Mode          | Description                                     |
|---------------------|---------------|-------------------------------------------------|
| `fb`                | Normal        | fuzzy buffers search                            |
| `ff`                | Normal        | fuzzy file search                               |
| `fg`                | Normal/Visual | grep project or grep visual selection           |
| `fh`                | Normal        | fuzzy find help pages                           |
| `fj`                | Normal        | fuzzy find jumps                                |
| `fl`                | Normal        | fuzzy find in current buffer                    |
| `fm`                | Normal        | fuzzy marks file search                         |
| `fo`                | Normal        | fuzzy mru file search                           |
| `fr`                | Normal        | resume last search                              |
| `ft`                | Normal        | fuzzy find tags                                 |
| `fc`                | Normal        | select colorscheme                              |
| `fe`                | Normal        | open file explorer                              |
| `go`                | Normal        | ctags outline                                   |
| `gO`                | Normal        | ctags all buffer outline                        |
| `gd`                | Normal        | goto definitions, fallback to tags              |
| `gri`               | Normal        | lsp_implementations                             |
| `grr`               | Normal        | lsp_references                                  |
| `gt`                | Normal        | lsp_type_definitions                            |
| `gs`                | Normal        | lsp_signature_help                              |
| `gl`                | Normal        | show diagnostic float                           |
| `gD`                | Normal        | lsp_declaration                                 |
| `<leader>ld`        | Normal        | buffer diagnostics                              |
| `<leader>lr`        | Normal        | lsp_restart                                     |
| `<leader>h`         | Normal        | clangd switch source/header                     |
| `ta`                | Normal        | gen tags(ctags) and compile_commands.json       |
| `tc`                | Normal        | gen compile_commands.json                       |
| `tr`                | Normal        | remove tags and clang conf                      |
| `<leader>q`         | Normal        | delete current buffer                           |
| `<leader>gg`        | Normal        | lazygit                                         |
| `<leader>gb`        | Normal        | git blame line                                  |
| `<leader>gB`        | Normal        | git browse                                      |
| `<leader>gf`        | Normal        | lazygit current file history                    |
| `<leader>gl`        | Normal        | lazygit log                                     |
| `<leader>st`        | Normal        | todo list                                       |
| `<leader>rs`        | Normal        | just select                                     |
| `<leader>rj`        | Normal        | just                                            |
| `<leader>rb`        | Normal        | just build                                      |
| `<leader>rr`        | Normal        | just run current file                           |
| `<leader>yf`        | Normal        | copy filename                                   |
| `<leader>yr`        | Normal        | copy relative path                              |
| `<leader>yF`        | Normal        | copy full path                                  |
| `<leader>evl`       | Normal        | edit user config                                |
| `<leader>evp`       | Normal        | edit project config                             |
| `<leader>evc`       | Normal        | edit config dir                                 |
| `<leader>cda`       | Normal        | set working directory                           |
| `<leader>cdt`       | Normal        | set working directory for current tab           |
| `<leader>sa`        | Normal        | surround add                                    |
| `<leader>sd`        | Normal        | surround delete                                 |
| `<leader>sf`        | Normal        | surround find                                   |
| `<leader>sF`        | Normal        | surround find left                              |
| `<leader>sh`        | Normal        | surround highlight                              |
| `<leader>sr`        | Normal        | surround replace                                |
| `<leader>us`        | Normal        | toggle spell                                    |
| `<leader>uw`        | Normal        | toggle wrap                                     |
| `<leader>uL`        | Normal        | toggle relative number                          |
| `<leader>uc`        | Normal        | toggle conceallevel                             |
| `<leader>ub`        | Normal        | toggle background                               |
| `<leader>ud`        | Normal        | toggle diagnostics                              |
| `<leader>ul`        | Normal        | toggle line number                              |
| `<leader>uT`        | Normal        | toggle treesitter                               |
| `<leader>uh`        | Normal        | toggle inlay hints                              |
| `<leader>i`         | Normal        | toggle indent guides                            |
| `<leader>pu`        | Normal        | update plugins                                  |
| `<leader>pr`        | Normal        | remove unused plugins                           |
| `<leader>ds`        | Normal        | delete trailing space                           |
| `<leader>dm`        | Normal        | delete ^M                                       |
| `<leader>da`        | Normal        | delete ansi escape codes                        |
| `]q`                | Normal        | next quickfix error                             |
| `[q`                | Normal        | previous quickfix error                         |
| `Q`                 | Normal        | `map Q q`, `map q <nop>`                        |
