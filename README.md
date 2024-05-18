My NEOVIM config.

#### Install
```
git clone https://github.com/fcying/dotvim.git ~/.config/nvim
or
wget https://github.com/fcying/dotvim/releases/download/nvim_config/nvim_config_with_vendor.txz
tar xJf nvim_config_with_vendor.txz
mv nvim ~/.config/
```

#### nvim_config_with_vendor.zip
`nvim_config.zip` with `rg` `ctags` `lsp`

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
e.g. `.git/.nvim.lua`.  
if there is not `scm` dir, save `.nvim.lua` in workspace.
autoreload `..nvim.lua` after save this file.

#### config var
config var, modify it in `user config` or `project config`.  

* `Option`  
    Option for fuzzyfind and generate tags, default:
```
Option.dir = { ".root", ".svn", ".git", ".repo", ".ccls-cache", ".cache", ".ccache" }
Option.file = { "*.sw?", "~$*", "*.bak", "*.exe", "*.o", "*.so", "*.py[co]", "tags" }
Option.rg = { "--max-columns=300", "--iglob=!obj", "--iglob=!out" }
Option.mru = { "*.so", "*.exe", "*.py[co]", "*.sw?", "~$*", "*.bak", "*.tmp", "*.dll" }
Option.cconf = { ["*"] = { "-ferror-limit=0" }, c = { "gcc", "-c", "-std=c11" }, cpp = { "g++", "-c", "-std=c++14" } }
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

#### Shortcuts
default `<leader>` is `<space>`
| Shortcut          | Mode          | Description                                     |
|-------------------|---------------|-------------------------------------------------|
| `fb`              | Normal        | fuzzy buffers search                            |
| `ff`              | Normal        | fuzzy file search                               |
| `fg`              | Normal/Visual | search under cursor or search visual selection  |
| `fh`              | Normal        | fuzzy find help tags                            |
| `fj`              | Normal        | fuzzy find jumplist                             |
| `fl`              | Normal        | fuzzy find in current buffer                    |
| `fm`              | Normal        | fuzzy marks file search                         |
| `fo`              | Normal        | fuzzy mru file search                           |
| `fr`              | Normal        | resume last search                              |
| `ft`              | Normal        | fuzzy find tags                                 |
| `f/`              | Normal        | live grep                                       |
| `fc`              | Normal        | select colorscheme                              |
| `gsiw`            | Normal        | search under cursor (display in quickfix)       |
| `gs`              | Visual        | search visual selection (display in quickfix)   |
| `gd`              | Normal        | goto definitions                                |
| `gi`              | Normal        | lsp_implementations                             |
| `gr`              | Normal        | lsp_references                                  |
| `gt`              | Normal        | lsp_type_definitions                            |
| `go`              | Normal        | ctags outline                                   |
| `gO`              | Normal        | ctags all buffer outline                        |
| `K`               | Normal        | lsp_hover                                       |
| `<leader>la`      | Normal        | lsp_code_actions                                |
| `<leader>ls`      | Normal        | lsp_document_symbols                            |
| `<leader>ld`      | Normal        | lsp_diagnostics                                 |
| `]d`              | Normal        | lsp_goto_next_diagnostic                        |
| `[d`              | Normal        | lsp_goto_previous_diagnostic                    |
| `<leader>rn`      | Normal        | lsp_rename                                      |
| `tg`              | Normal        | gen tags(ctags) and compile_commands.json       |
| `tc`              | Normal        | remove tas and compile_commands.json            |
| `<leader>wf`      | Normal        | open file explorer                              |
| `<leader>wl`      | Normal        | locating current file in file explorer          |
| `gcc`             | Normal/Visual | comment toggle                                  |
| `<leader>fp`      | Normal/Visual | fold search                                     |
| `<leader>q`       | Normal        | close current buffer                            |
| `v`               | Visual        | expand select region                            |
| `V`               | Visual        | shrink select region                            |
| `s`               | Normal        | flash move to {char}                            |
| `S`               | Normal        | flash treesitter                                |
| `<leader>sa`      | Normal        | surround add                                    |
| `<leader>sd`      | Normal        | surround delete                                 |
| `<leader>sr`      | Normal        | surround replace                                |
| `<F2>`            | Normal        | toggle show number                              |
| `<F3>`            | Normal        | toggle show list                                |
| `<F4>`            | Normal        | toggle wrap                                     |
| `<F6>`            | Normal        | toggle syntax                                   |
| `<F5>`/`<leader>z`| Normal        | toggle paste                                    |
| `Q`               | Normal        | `map Q q`, `map q <nop>`                        |
| `<leader>ds`      | Normal        | delete trailing space                           |
| `<leader>dm`      | Normal        | delete ^M                                       |
| `<leader>da`      | Normal        | delete ansi escape codes                        |
| `<leader>pu`      | Normal        | update plugins                                  |
| `<leader>pr`      | Normal        | remove unused plugins                           |

