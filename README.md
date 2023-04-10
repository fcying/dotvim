My NEOVIM config.

#### Install
```
git clone https://github.com/fcying/dotvim.git ~/.config/nvim
```

#### nvim_config.zip (only support NVIM 0.8+)
```
download from release
tar xJf nvim_config.txz
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
`<leader>ep`  
modify project config.  
e.g. `.git/.pvimrc`.  
if there is not `scm` dir, save `.pvimrc` in workspace.
autoreload `.pvimrc` after save this file.

#### config var
config var, modify it in `user config` or `project config`.  

* `g:ignore`  
    ignore config for fuzzyfind and generate tags
```
let g:ignore.dir = ['.root','.svn','.git','.repo','.ccls-cache','.cache','.ccache']
let g:ignore.file = ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]'
let g:ignore.rg = ['--max-columns=300', '--iglob=!obj', '--iglob=!out']
let g:ignore.mru = ['*.so', '*.exe', '*.py[co]', '*.sw?', '~$*', '*.bak', '*.tmp', '*.dll']
```

* `g:colorscheme`  
    e.g.  
    ```
    let g:colorscheme='solarized8'
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
| `fm`              | Normal        | fuzzy mru file search                           |
| `fo`              | Normal        | ctags outline                                   |
| `fO`              | Normal        | ctags all buffer outline                        |
| `fr`              | Normal        | resume last search                              |
| `ft`              | Normal        | fuzzy find tags                                 |
| `f/`              | Normal        | live grep                                       |
| `gsiw`            | Normal        | search under cursor (display in quickfix)       |
| `gs`              | Visual        | search visual selection (display in quickfix)   |
| `gd`              | Normal        | goto definitions                                |
| `gI`              | Normal        | lsp_implementations                             |
| `gr`              | Normal        | lsp_references                                  |
| `gt`              | Normal        | lsp_type_definitions                            |
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
| `<leader>gc`      | Normal/Visual | comment toggle                                  |
| `<leader>gC`      | Visual        | comment                                         |
| `<leader>gU`      | Visual        | uncomment                                       |
| `<leader>gi`      | Normal/Visual | comment invert                                  |
| `<leader>fp`      | Normal/Visual | fold search                                     |
| `<leader>q`       | Normal        | close current buffer                            |
| `v`               | Visual        | expand select region                            |
| `V`               | Visual        | shrink select region                            |
| `s`               | Normal        | move to {char}                                  |
| `S`               | Normal        | move to {char}{char}                            |
| `L`               | Normal        | move to line                                    |
| `<leader>sa`      | Normal        | surround add                                    |
| `<leader>sd`      | Normal        | surround delete                                 |
| `<leader>sr`      | Normal        | surround replace                                |
| `<F2>`            | Normal        | toggle show number                              |
| `<F3>`            | Normal        | toggle show list                                |
| `<F4>`            | Normal        | toggle wrap                                     |
| `<F6>`            | Normal        | toggle syntax                                   |
| `<F5>`/`<leader>z`| Normal        | toggle paste                                    |
| `Q`               | Normal        | `map Q q`, `map q <nop>`, `map gQ Q`            |
| `<leader>ds`      | Normal        | delete trailing space                           |
| `<leader>dm`      | Normal        | delete ^M                                       |
| `<leader>da`      | Normal        | delete ansi escape codes                        |
| `<leader>pu`      | Normal        | update plugins                                  |
| `<leader>pr`      | Normal        | remove unused plugins                           |
| `<leader>pc`      | Normal        | PackerCompile(packer)                           |

