"deoplete ncm async neocomplete ycm
let g:complete_func = get(g:, 'complete_func', 'neocomplete')


" ============================================================================
" plug func {{{
" ============================================================================
function! s:load_plugins() abort
    for plugin in g:plug_list
        if len(plugin) == 2
            exec "Plug " . "'" . plugin[0] . "', " . string(plugin[1])
        else
            exec "Plug " . "'" . plugin[0] . "'"
        endif
    endfor
endfunction

function! BuildVimproc(info)
    " info is a dictionary with 3 fields
    " - name:   name of the plugin
    " - status: 'installed', 'updated', or 'unchanged'
    " - force:  set on PlugInstall! or PlugUpdate!
    if a:info.status != 'unchanged' || a:info.force
        silent !echo "update vimproc"
        if g:os_windows
            silent !Tools\update-dll-mingw.bat
        else
            silent !make
        endif
    endif
endfunction

function! MakeDeopleteGo(info)
    if a:info.status != 'unchanged' || a:info.force
        silent !echo "update goimports godef gotags"
        silent !go get -u golang.org/x/tools/cmd/goimports
        silent !go get -u github.com/rogpeppe/godef
        silent !go get -u github.com/jstemmer/gotags
        if g:os_windows
            silent !taskkill /F /IM gocode.exe
            silent !go get -u -ldflags -H=windowsgui github.com/nsf/gocode
            call system('mingw32-make')
            silent !gocode set lib-path %GOPATH%\pkg\windows_386
        else
            silent !go get -u github.com/nsf/gocode
            call system('make')
            silent !gocode set lib-path $GOPATH/pkg/linux_amd64
        endif
    endif
endfunction

function! GetGoCode(info)
    if a:info.status != 'unchanged' || a:info.force
        if executable('go')
            silent !echo "update goimports godef gotags"
            silent !go get -u golang.org/x/tools/cmd/goimports
            silent !go get -u github.com/rogpeppe/godef
            silent !go get -u github.com/jstemmer/gotags
            if g:os_windows
                silent !taskkill /F /IM gocode.exe
                silent !go get -u -ldflags -H=windowsgui github.com/nsf/gocode
                "silent !go get -u github.com/nsf/gocode
                let l:cmd = 'cp -R ' . g:config_dir . '\plugged\gocode\vim\ftplugin '
                            \ . $HOME . '\vimfiles'
                call system(l:cmd)
                let l:cmd = 'cp -R ' . g:config_dir . '\plugged\gocode\vim\autoload ' . $HOME
                            \ . '\vimfiles'
                call system(l:cmd)
                silent !gocode set lib-path %GOPATH%\pkg\windows_386
            else
                silent !killall gocode
                silent !go get -u github.com/nsf/gocode
                let l:cmd = 'sh ' . g:config_dir . '/plugged/gocode/vim/update.sh'
                call system(l:cmd)
                silent !gocode set lib-path $GOPATH/pkg/linux_amd64
            endif
        endif
    endif
endfunction
"}}}


" ============================================================================
" plugin {{{
" ============================================================================
let g:plug_list = []
call add(g:plug_list, ['junegunn/vim-plug'])
call add(g:plug_list, ['mbbill/fencview'])
call add(g:plug_list, ['adah1972/tellenc'])
call add(g:plug_list, ['sheerun/vim-polyglot'])   "A solid language pack for Vim.
call add(g:plug_list, ['bogado/file-line'])
"call add(g:plug_list, ['Raimondi/delimitMate'])
call add(g:plug_list, ['jiangmiao/auto-pairs'])
call add(g:plug_list, ['tpope/vim-surround'])
call add(g:plug_list, ['itchyny/lightline.vim'])
if exists("g:vim-paste-easy")
    call add(g:plug_list, ['roxma/vim-paste-easy'])
endif
"let g:paste_easy_enable = 0
call add(g:plug_list, ['t9md/vim-choosewin', {'on':'<Plug>(choosewin)'}])
call add(g:plug_list, ['moll/vim-bbye', {'on':'Bdelete'}])
call add(g:plug_list, ['MattesGroeger/vim-bookmarks'])
call add(g:plug_list, ['thinca/vim-ref'])
call add(g:plug_list, ['terryma/vim-expand-region'])
call add(g:plug_list, ['terryma/vim-multiple-cursors'])
call add(g:plug_list, ['dyng/ctrlsf.vim'])
call add(g:plug_list, ['easymotion/vim-easymotion'])
call add(g:plug_list, ['derekwyatt/vim-fswitch'])
call add(g:plug_list, ['nathanaelkane/vim-indent-guides', {'on':'<Plug>IndentGuidesToggle'}])
call add(g:plug_list, ['scrooloose/nerdtree', {'on':'NERDTreeToggle'}])
call add(g:plug_list, ['scrooloose/nerdcommenter', {'on':'<Plug>NERDCommenterToggle'}])
call add(g:plug_list, ['majutsushi/tagbar', {'on':'TagbarToggle'}])
call add(g:plug_list, ['xolox/vim-session'])
call add(g:plug_list, ['xolox/vim-misc'])

if g:os_windows 
    call add(g:plug_list, ['Yggdroot/LeaderF', {'do': '.\install.bat'}])
else
    call add(g:plug_list, ['Yggdroot/LeaderF', {'do': './install.sh'}])
endif
call add(g:plug_list, ['Shougo/vimproc.vim', {'do':function('BuildVimproc')}])
"call add(g:plug_list, ['Shougo/vimshell', {'on': 'VimShell'}])
"call add(g:plug_list, ['lambdalisue/gina.vim', {'on': 'Gina'}])

call add(g:plug_list, ['ludovicchabant/vim-gutentags'])
call add(g:plug_list, ['skywind3000/gutentags_plus'])
call add(g:plug_list, ['skywind3000/vim-preview'])

if g:complete_func == 'deoplete'
    if has('nvim')
       call add(g:plug_list, ['Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}])
    else
       call add(g:plug_list, ['Shougo/deoplete.nvim'])
       call add(g:plug_list, ['zchee/deoplete-clang'])
       call add(g:plug_list, ['roxma/nvim-yarp'])
       call add(g:plug_list, ['roxma/vim-hug-neovim-rpc'])
    endif
    call add(g:plug_list, ['Shougo/neco-syntax'])
    call add(g:plug_list, ['zchee/deoplete-jedi', {'for':'python'}])
    call add(g:plug_list, ['zchee/deoplete-go', {'for':'go', 'do':function('MakeDeopleteGo')}])
elseif g:complete_func == 'async'
    call add(g:plug_list, ['prabirshrestha/async.vim'])
    call add(g:plug_list, ['prabirshrestha/asyncomplete.vim'])
    call add(g:plug_list, ['prabirshrestha/vim-lsp'])
    call add(g:plug_list, ['prabirshrestha/asyncomplete-lsp.vim'])
    call add(g:plug_list, ['prabirshrestha/asyncomplete-tags.vim'])
    call add(g:plug_list, ['prabirshrestha/asyncomplete-buffer.vim'])
    call add(g:plug_list, ['prabirshrestha/asyncomplete-file.vim'])
    call add(g:plug_list, ['yami-beta/asyncomplete-omni.vim'])
    call add(g:plug_list, ['prabirshrestha/asyncomplete-necosyntax.vim'])
    call add(g:plug_list, ['prabirshrestha/asyncomplete-necovim.vim'])
    call add(g:plug_list, ['prabirshrestha/asyncomplete-gocode.vim'])
    "call add(g:plug_list, ['wellle/tmux-complete.vim'])
elseif g:complete_func == 'ncm'
    if !has('nvim')
        call add(g:plug_list, ['roxma/vim-hug-neovim-rpc'])
    else
        call add(g:plug_list, ['autozimu/LanguageClient-neovim', {'do': ':UpdateRemotePlugins'}])
    endif
    call add(g:plug_list, ['roxma/ncm-clang'])
    "call add(g:plug_list, ['roxma/nvim-completion-manager'])
    call add(g:plug_list, ['fcying/nvim-completion-manager'])
elseif g:complete_func == 'ycm'
    call add(g:plug_list, ['Valloric/YouCompleteMe'])
else
    if has('lua')
        call add(g:plug_list, ['Shougo/neocomplete'])
        call add(g:plug_list, ['davidhalter/jedi-vim', {'for':'python'}])
        call add(g:plug_list, ['Shougo/neoinclude.vim'])
        call add(g:plug_list, ['Shougo/neco-syntax'])
        call add(g:plug_list, ['Shougo/neco-vim'])
        call add(g:plug_list, ['nsf/gocode', {'do':function('GetGoCode'), 'for':'go'}])
        call add(g:plug_list, ['dgryski/vim-godef', {'for':'go'}])
    endif
endif

call add(g:plug_list, ['vim-scripts/autohotkey-ahk', {'for':'autohotkey'}])
call add(g:plug_list, ['huleiak47/vim-AHKcomplete', {'for':'autohotkey'}])
call add(g:plug_list, ['godlygeek/tabular', {'for':'markdown'}])
call add(g:plug_list, ['plasticboy/vim-markdown', {'for':'markdown'}])

"color
"call add(g:plug_list, ['altercation/vim-colors-solarized'])
call add(g:plug_list, ['fcying/vim-colors-solarized'])
call add(g:plug_list, ['tomasr/molokai'])
call add(g:plug_list, ['icymind/NeoSolarized'])
"}}}


let g:plug_dir = g:config_dir . '/plugged'
if filereadable(expand(g:plug_dir . '/vim-plug/plug.vim')) == 0
    if executable('git')
        let s:first_install=1
        silent exec '!git clone --depth 1 https://github.com/junegunn/vim-plug '
                    \ . g:plug_dir . '/vim-plug'
    else
        echohl WarningMsg
        echom 'You need install git!'
        echohl None
    endif
endif
exec 'source '. g:plug_dir . '/vim-plug/plug.vim'
call plug#begin(expand(g:plug_dir))
call s:load_plugins()
call plug#end()



" auto install
let g:plug_auto_install = get(g:, 'plug_auto_install', 'false')
if g:plug_auto_install == 'true' || exists("s:first_install")
    let s:plug_list_cache=g:config_dir . '/.cache/plug_list_cache'
    if !isdirectory(g:config_dir . "/.cache")
        call mkdir(g:config_dir . "/.cache")
    endif
    if filereadable(s:plug_list_cache)
        let s:last_plug_list=readfile(s:plug_list_cache, "b")
    else
        let s:last_plug_list=[]
        echom "no plug_list_cache"
    endif
    let s:plug_string=[string(g:plug_list)]
    if s:last_plug_list != s:plug_string
        call writefile(s:plug_string, s:plug_list_cache, "b")
        echom "update plug_list_cache"
        silent PlugInstall
    endif
endif



" ============================================================================
" plugin settings {{{
" ============================================================================
let s:plug_list_string = string(g:plug_list)

function! s:findplug(plugname)
    return stridx(s:plug_list_string, a:plugname)
endfunction


if (s:findplug('vim-indent-guides') != -1)
    let g:indent_guides_enable_on_vim_startup=0
    let g:indent_guides_start_level=2
    let g:indent_guides_guide_size=1
    :nmap <silent> <Leader>i <Plug>IndentGuidesToggle
endif

if (s:findplug('gutentags_plus') != -1)
    " enable gtags module
    let g:gutentags_modules = ['ctags', 'gtags_cscope']
    " config project root markers.
    let g:gutentags_project_root = ['.root']
    " generate datebases in my cache directory, prevent gtags files polluting my project
    let g:gutentags_cache_dir = expand($HOME . '/.cache/tags')
    " forbid gutentags adding gtags databases
    let g:gutentags_auto_add_gtags_cscope = 0
    let g:gutentags_plus_nomap = 1
    noremap <silent> <leader>gs :GscopeFind s <C-R><C-W><cr>
    noremap <silent> <leader>gg :GscopeFind g <C-R><C-W><cr>
    noremap <silent> <leader>gc :GscopeFind c <C-R><C-W><cr>
    noremap <silent> <leader>gt :GscopeFind t <C-R><C-W><cr>
    noremap <silent> <leader>ge :GscopeFind e <C-R><C-W><cr>
    noremap <silent> <leader>gf :GscopeFind f <C-R>=expand("<cfile>")<cr><cr>
    noremap <silent> <leader>gi :GscopeFind i <C-R>=expand("<cfile>")<cr><cr>
    noremap <silent> <leader>gd :GscopeFind d <C-R><C-W><cr>
    noremap <silent> <leader>ga :GscopeFind a <C-R><C-W><cr>
    autocmd FileType qf nnoremap <silent><buffer> p :PreviewQuickfix<cr>
    autocmd FileType qf nnoremap <silent><buffer> P :PreviewClose<cr>
endif

if (s:findplug('lightline') != -1)
    set showtabline=1
    "let g:lightline = {'colorscheme': 'default'}
    let g:lightline = {'colorscheme': 'solarized'}
    let g:lightline.enable = {
        \ 'statusline': 1,
        \ 'tabline': 1
        \ }
    noremap <silent><leader>tc :tabnew<cr>
    noremap <silent><leader>tq :tabclose<cr>
    noremap <silent><leader>tn :tabn<cr>
    noremap <silent><leader>tp :tabp<cr>
    noremap <silent><leader>1 :tabn 1<cr>
    noremap <silent><leader>2 :tabn 2<cr>
    noremap <silent><leader>3 :tabn 3<cr>
    noremap <silent><leader>4 :tabn 4<cr>
    noremap <silent><leader>5 :tabn 5<cr>
    noremap <silent><leader>6 :tabn 6<cr>
    noremap <silent><leader>7 :tabn 7<cr>
    noremap <silent><leader>8 :tabn 8<cr>
    noremap <silent><leader>9 :tabn 9<cr>
    noremap <silent><leader>0 :tabn 10<cr>
    noremap <silent><s-tab> :tabnext<CR>
    inoremap <silent><s-tab> <ESC>:tabnext<CR>
endif

if (s:findplug('vim-expand-region') != -1)
    xmap v <Plug>(expand_region_expand)
    xmap V <Plug>(expand_region_shrink)
    let g:expand_region_text_objects = {
          \ 'iw'  :0,
          \ 'iW'  :0,
          \ 'i"'  :0,
          \ 'i''' :0,
          \ 'i]'  :1,
          \ 'ib'  :1,
          \ 'iB'  :1,
          \ 'il'  :1,
          \ 'ii'  :1,
          \ 'ip'  :0,
          \ 'ie'  :0,
          \ }
endif

if (s:findplug('gina') != -1)
    nnoremap <silent> <leader>gst    :Gina status<CR>
    nnoremap <silent> <leader>gU     :Gina reset -q %<CR>
    nnoremap <silent> <leader>gca    :Gina commit -a<CR>
    nnoremap <silent> <leader>gcam   :Gina commit -a --amend<CR>
    nnoremap <silent> <leader>gd     :Gina diff<CR>
    nnoremap <silent> <leader>gp     :Gina push<CR>
    nnoremap <silent> <leader>ga     :Gina add %<CR>
    nnoremap <silent> <leader>gA     :Gina add .<CR>
    nnoremap <silent> <leader>gl     :Gina pull<CR>
    nnoremap <silent> <leader>glg    :Gina log<CR>
    nnoremap <silent> <leader>gb     :Gina blame<CR>
endif

if (s:findplug('LanguageClient-neovim') != -1)
    nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
    nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
    nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
    set hidden
    let g:LanguageClient_autoStart = 1
    let g:LanguageClient_serverCommands = {
                \ 'c': ['clangd'],
                \ 'cpp': ['clangd']
                \ }
endif

if (s:findplug('asyncomplete.vim') != -1) "{{{
    if (s:findplug('tmux-complete.vim') != -1)
        let g:tmuxcomplete#asyncomplete_source_options = {
                    \ 'name':      'tmuxcomplete',
                    \ 'whitelist': ['*'],
                    \ 'config': {
                    \     'splitmode':      'words',
                    \     'filter_prefix':   1,
                    \     'show_incomplete': 1,
                    \     'sort_candidates': 0,
                    \     'scrollback':      0,
                    \     'truncate':        0
                    \     }
                    \ }
    endif
    if (s:findplug('asyncomplete-buffer.vim') != -1)
        call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
            \ 'name': 'buffer',
            \ 'whitelist': ['*'],
            \ 'blacklist': ['go'],
            \ 'completor': function('asyncomplete#sources#buffer#completor'),
            \ }))
    endif
    if (s:findplug('asyncomplete-necosyntax.vim') != -1)
        au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#necosyntax#get_source_options({
            \ 'name': 'necosyntax',
            \ 'whitelist': ['*'],
            \ 'completor': function('asyncomplete#sources#necosyntax#completor'),
            \ }))
    endif
    if (s:findplug('asyncomplete-file.vim') != -1)
        au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
            \ 'name': 'file',
            \ 'whitelist': ['*'],
            \ 'priority': 10,
            \ 'completor': function('asyncomplete#sources#file#completor')
            \ }))
    endif
    if (s:findplug('asyncomplete-tags.vim') != -1)
        au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#tags#get_source_options({
            \ 'name': 'tags',
            \ 'whitelist': ['c','cpp'],
            \ 'completor': function('asyncomplete#sources#tags#completor'),
            \ 'config': {
            \    'max_file_size': 50000000,
            \  },
            \ }))
    endif
    if (s:findplug('asyncomplete-necovim.vim') != -1)
        au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#necovim#get_source_options({
        \ 'name': 'necovim',
        \ 'whitelist': ['vim'],
        \ 'completor': function('asyncomplete#sources#necovim#completor'),
        \ }))
    endif
    if (s:findplug('asyncomplete-gocode.vim') != -1)
        call asyncomplete#register_source(asyncomplete#sources#gocode#get_source_options({
            \ 'name': 'gocode',
            \ 'whitelist': ['go'],
            \ 'completor': function('asyncomplete#sources#gocode#completor'),
            \ 'config': {
            \    'gocode_path': expand('~/go/bin/gocode')
            \  },
            \ }))
    endif    
    if (s:findplug('asyncomplete-omni.vim') != -1)
        call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
        \ 'name': 'omni',
        \ 'whitelist': ['*'],
        \ 'blacklist': ['c', 'cpp', 'html'],
        \ 'completor': function('asyncomplete#sources#omni#completor')
        \  }))
    endif     
    let g:asyncomplete_remove_duplicates = 1
    "let g:lsp_log_verbose = 1
    "let g:lsp_log_file = expand('~/vim-lsp.log')
    "let g:asyncomplete_log_file = expand('~/asyncomplete.log')
endif
"}}}

if (s:findplug('vim-lsp') != -1)
    if executable('pyls')
        " pip install python-language-server
        au User lsp_setup call lsp#register_server({
            \ 'name': 'pyls',
            \ 'cmd': {server_info->['pyls']},
            \ 'whitelist': ['python'],
            \ })
    endif
endif

if (s:findplug('YouCompleteMe') != -1) "{{{
    "let g:ycm_key_list_select_completion=['<c-n>']
    let g:ycm_key_list_select_completion = ['<Down>']
    "let g:ycm_key_list_previous_completion=['<c-p>']
    let g:ycm_key_list_previous_completion = ['<Up>']
    let g:ycm_complete_in_comments = 1
    let g:ycm_complete_in_strings = 1 
    let g:ycm_use_ultisnips_completer = 0
    let g:ycm_collect_identifiers_from_comments_and_strings = 1
    let g:ycm_collect_identifiers_from_tags_files = 1
    let g:ycm_seed_identifiers_with_syntax=1
    let g:ycm_key_list_stop_completion = ['<CR>']

    let g:ycm_seed_identifiers_with_syntax=1

    let g:ycm_goto_buffer_command = 'horizontal-split'
    let g:ycm_register_as_syntastic_checker = 0
    nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
    nnoremap <leader>gd :YcmCompleter GoToDeclaration<CR>

    if !empty(glob(g:config_dir . "plug/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py"))
        let g:ycm_global_ycm_extra_conf = g:config_dir . "plug/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py"
    endif

    " let g:ycm_key_invoke_completion = '<C-Space>'
    let g:ycm_filetype_blacklist = {
        \ 'tagbar' : 1,
        \ 'gitcommit' : 1,
        \}
endif 
"}}}

if (s:findplug('deoplete') != -1) "{{{
    " deoplete options
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#enable_smart_case = 1
    let g:deoplete#ignore_sources = {}

    call deoplete#custom#option('keyword_patterns', {
        \ '_': '[a-zA-Z_]\k*',
        \ 'tex': '\\?[a-zA-Z_]\w*',
        \ 'ruby': '[a-zA-Z_]\w*[!?]?',
        \})
    
    call deoplete#custom#option('omni_patterns', {
        \ 'java': '[^. *\t]\.\w*',
        \ 'c': '[^. *\t]\(\.\|->\)\w*',
        \ 'cpp': '[^. *\t]\(\.\|->\)\w*',
        \})
    
    let g:deoplete#sources#jedi#server_timeout = 10
    if !exists('g:deoplete#sources#jedi#extra_path')
        let g:deoplete#sources#jedi#extra_path=[
            \ "/home/linuxbrew/.linuxbrew/lib/python3.6/site-packages",
            \ ]  
    endif

    "call deoplete#custom#option('profile', v:true)
    "call deoplete#enable_logging('DEBUG', 'deoplete.log')
    "call deoplete#custom#source('jedi', 'is_debug_enabled', 1)        
    "let g:deoplete#sources#jedi#debug_server = "jedi.log"
    
    inoremap <expr><C-h> deoplete#mappings#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> deoplete#mappings#smart_close_popup()."\<C-h>"
    set isfname-==

    " <CR>: close popup and save indent.
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function() abort
        return deoplete#close_popup() . "\<CR>"
    endfunction
endif
"}}}

if (s:findplug('neocomplete') != -1) "{{{
    let g:neocomplete#data_directory= g:config_dir . '/.cache/neocomplete'
    let g:acp_enableAtStartup = 0
    let g:neocomplete#enable_at_startup = 1
    " Use smartcase.
    let g:neocomplete#enable_smart_case = 1
    let g:neocomplete#enable_camel_case = 1
    "let g:neocomplete#enable_ignore_case = 1
    let g:neocomplete#enable_fuzzy_completion = 1
    " Set minimum syntax keyword length.
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

    " Define dictionary.
    let g:neocomplete#sources#dictionary#dictionaries =
          \ {
          \ 'default' : '',
          \ 'vimshell' : g:config_dir . '/.cache/vimshell/command-history',
          \ 'java' : g:config_dir . '/.cache/dict/java.dict',
          \ 'ruby' : g:config_dir . '/.cache/dict/ruby.dict',
          \ 'scala' : g:config_dir . '/.cache/dict/scala.dict',
          \ }

    let g:neocomplete#enable_auto_delimiter = 1

    " neco-vim
    if !exists('g:necovim#complete_functions')
        let g:necovim#complete_functions = {}
    endif
    let g:necovim#complete_functions.Ref =
                \ 'ref#complete'

    " Define keyword.
    if !exists('g:neocomplete#keyword_patterns')
      let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns._ =
          \ get(g:neocomplete#keyword_patterns, '_', '\h\k*(\?')

    " AutoComplPop like behavior.
    let g:neocomplete#enable_auto_select = 0

    if !exists('g:neocomplete#sources#omni#input_patterns')
      let g:neocomplete#sources#omni#input_patterns = {}
    endif

    let g:neocomplete#sources#omni#input_patterns.perl =
          \ get(g:neocomplete#sources#omni#input_patterns, 'perl',
          \ '\h\w*->\h\w*\|\h\w*::')
    let g:neocomplete#sources#omni#input_patterns.java =
          \ get(g:neocomplete#sources#omni#input_patterns, 'java',
          \ '[^. \t0-9]\.\w*')
    let g:neocomplete#sources#omni#input_patterns.lua =
          \ get(g:neocomplete#sources#omni#input_patterns, 'lua',
          \ '[^. \t0-9]\.\w*')
    let g:neocomplete#sources#omni#input_patterns.c =
          \ get(g:neocomplete#sources#omni#input_patterns, 'c',
          \ '[^.[:digit:] *\t]\%(\.\|->\)')
    let g:neocomplete#sources#omni#input_patterns.cpp =
          \ get(g:neocomplete#sources#omni#input_patterns, 'cpp',
          \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::')
    if !exists('g:neocomplete#force_omni_input_patterns')
      let g:neocomplete#force_omni_input_patterns = {}
    endif
    "let g:neocomplete#force_omni_input_patterns.java = '^\s*'

	autocmd FileType python setlocal omnifunc=jedi#completions
	let g:jedi#completions_enabled = 0
	let g:jedi#auto_vim_configuration = 0
	let g:jedi#smart_auto_mappings = 0
	let g:neocomplete#force_omni_input_patterns.python =
	\ '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
	" alternative pattern: '\h\w*\|[^. \t]\.\w*'

    " <C-h>, <BS>: close popup and delete backword char.
    "inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
    "inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><C-y>  neocomplete#close_popup()
    inoremap <expr><C-e>  neocomplete#cancel_popup()
    inoremap <expr><C-l>  neocomplete#start_manual_complete()
    inoremap <expr><C-x><c-u>  neocomplete#start_manual_complete()

    " <CR>: close popup and save indent.
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
      return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
      " For no inserting <CR> key.
      "return pumvisible() ? "\<C-y>" : "\<CR>"
    endfunction
endif
"}}}

if (s:findplug('vim-multiple-cursors') != -1)
    "let g:multi_cursor_next_key='<S-n>'
    "let g:multi_cursor_prev_key='<S-p>'
    "let g:multi_cursor_skip_key='<S-x>'
    let g:multi_cursor_quit_key='<Esc>'
    " Called once right before you start selecting multiple cursors
    function! Multiple_cursors_before()
        if exists(':NeoCompleteLock')==2
            exe 'NeoCompleteLock'
        endif
    endfunction

    " Called once only when the multiple selection is canceled (default <Esc>)
    function! Multiple_cursors_after()
        if exists(':NeoCompleteUnlock')==2
            exe 'NeoCompleteUnlock'
        endif
        let g:deoplete#disable_auto_complete = 0
    endfunction

    function! g:Multiple_cursors_before()
        let g:deoplete#disable_auto_complete = 1
    endfunction
endif

if (s:findplug('nerdtree') != -1)
    nmap <leader>nt :NERDTreeToggle<cr>
    nmap <F12> :NERDTreeToggle<cr>
    let NERDTreeWinSize=32
    let NERDTreeWinPos="right"
    let NERDTreeShowHidden=1
    let NERDTreeMinimalUI=1
    let NERDTreeAutoDeleteBuffer=1
    let NERDTreeShowBookmarks=1
    let NERDTreeShowLineNumbers=1
    let NERDTreeShowHidden=1

    let NERDTreeIgnore=['GPATH', 'tags', 'GRTAGS', 'GTAGS', 'GSYMS', '\~$']
endif

if (s:findplug('ctrlsf') != -1)
    "let g:ctrlsf_debug_mode = 1
    "redir! > ctrlsf.log
    let g:ctrlsf_ackprg = 'rg'
    let g:ctrlsf_regex_pattern = 1
    let g:ctrlsf_case_sensitive = 'smart'
    let g:ctrlsf_ignore_dir = ['tags', 'GTAGS', 'GPATH', 'GRTAGS', 'obj', 'out', 'Out']

    nmap <leader>sf <Plug>CtrlSFCwordExec
    nmap <leader>sF <Plug>CtrlSFPrompt
    vmap <leader>sf <Plug>CtrlSFVwordExec
    vmap <leader>sF <Plug>CtrlSFVwordPath
    nmap <leader>sp <Plug>CtrlSFPwordPath
    nnoremap <leader>so :CtrlSFOpen<CR>
    nnoremap <leader>st :CtrlSFToggle<CR>
    inoremap <leader>st <Esc>:CtrlSFToggle<CR>

    let g:ctrlsf_mapping = {
        \ "next"    : "<c-w>",
        \ "prev"    : "<c-e>",
        \ }

    autocmd! FileType ctrlsf call s:ctrlsf_settings()
    function! s:ctrlsf_settings()
        nmap <buffer> <c-j> <c-w>p
        nmap <buffer> <c-k> <c-e>p
    endfunction
endif

if (s:findplug('vim-session') != -1)
    let g:session_autosave = 'no'
    let g:session_autoload = 'no'
endif

if (s:findplug('LeaderF') != -1)
    let g:Lf_PreviewCode = 0
    let g:Lf_DefaultMode = 'FullPath'
    let g:Lf_WildIgnore = {
           \ 'dir': ['.svn','.git','.hg'],
           \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
           \}

    nnoremap ff :<C-u>LeaderfFile<CR>
    nnoremap fb :<C-u>LeaderfBuffer<CR>
    nnoremap fl :<C-u>LeaderfLine<CR>
    nnoremap fo :<C-u>LeaderfFunction<CR>
    nnoremap ft :<C-u>LeaderfTag<CR>
    nnoremap fm :<C-u>LeaderfMru<CR>
    nnoremap fh :<C-u>LeaderfHistorySearch<CR>
    nnoremap fg :<C-u>CtrlSF
endif

if (s:findplug('denite') != -1) "{{{
    if executable('rg')
        call denite#custom#var('grep', 'command', ['rg'])
        call denite#custom#var('file_rec', 'command',
            \ ['rg', '--files', '--hidden', '--follow',
            \ '-g','!out', '-g','!obj', '-g', '!deploy',
            \ '-g','!tags', '-g','!GTAGS', '-g','!GRTAGS', '-g','!GPATH',
            \ '-g', '!.git', '-g', '!.svn'])
        call denite#custom#var('grep', 'default_opts',
            \ ['--vimgrep', '--no-heading'])
        call denite#custom#var('grep', 'recursive_opts', [])
        call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
        call denite#custom#var('grep', 'separator', ['--'])
        call denite#custom#var('grep', 'final_opts', [])
    elseif executable('pt')
        call denite#custom#var('grep', 'command', ['pt'])
        call denite#custom#var('file_rec', 'command',
            \ ['pt', '--follow', '--nocolor', '--nogroup', '--hidden',
            \ '--ignore','lib', '--ignore','obj', '--ignore','out',
            \ '--ignore','deploy',
            \ '--ignore','tags', '--ignore','GTAGS', '--ignore','GRTAGS', '--ignore','GPATH',
            \ '--ignore','.git', '--ignore','.svn', '-g', ''])
        call denite#custom#var('grep', 'default_opts',
            \ ['--nogroup', '--nocolor', '--smart-case', '--hidden',
            \ '--ignore','lib', '--ignore','obj', '--ignore','out',
            \ '--ignore','deploy',
            \ '--ignore','tags', '--ignore','GTAGS', '--ignore','GRTAGS', '--ignore','GPATH',
            \ '--ignore','.git', '--ignore','.svn'])
        call denite#custom#var('grep', 'recursive_opts', [])
        call denite#custom#var('grep', 'pattern_opt', [])
        call denite#custom#var('grep', 'separator', ['--'])
        call denite#custom#var('grep', 'final_opts', [])
    endif

    call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
        \ [ '.git/', '.ropeproject/', '__pycache__/',
        \ 'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])

    call denite#custom#source('file_mru', 'converters',
        \ ['converter_relative_word'])

    " Change matchers.
    call denite#custom#source('file_mru', 'matchers', ['matcher_fuzzy', 'matcher_project_files'])
    "call denite#custom#source('file_rec', 'matchers', ['matcher_cpsm'])

    " Change sorters.
    call denite#custom#source('file_rec', 'sorters', ['sorter_sublime'])

    nnoremap [Denite] <Nop>
    nmap f [Denite]
    nmap <c-p> [Denite]
    nnoremap [Denite]f :<C-u>Denite file_rec<CR>
    "nnoremap [Denite]f :<C-u>FZF<CR>
    nnoremap [Denite]F :<C-u>Denite file_rec
    nnoremap [Denite]b :<C-u>Denite buffer bookmark<CR>
    nnoremap [Denite]g :<C-u>Denite grep:.<CR>
    nnoremap [Denite]l :<C-u>Denite line<CR>
    nnoremap [Denite]o :<C-u>Denite outline<CR>
    nnoremap [Denite]h :<C-u>Denite history/yank<CR>
    nnoremap [Denite]m :<C-u>Denite file_mru<CR>
    nnoremap [Denite]p :<C-u>Denite jump_point file_point<CR>
    "nnoremap [Denite]s :<C-u>Denite source<CR>

    " KEY MAPPINGS
    let s:insert_mode_mappings = [
            \ ['<Tab>', '<denite:move_to_next_line>', 'noremap'],
            \ ['<S-tab>', '<denite:move_to_previous_line>', 'noremap'],
            \ ['<C-j>', '<denite:move_to_next_line>', 'noremap'],
            \ ['<C-k>', '<denite:move_to_previous_line>', 'noremap'],
            \ ['<C-t>', '<denite:move_to_first_line>', 'noremap'],
            \ ['<C-b>', '<denite:move_to_last_line>', 'noremap'],
            \ ]

    let s:normal_mode_mappings = [
            \ ["'", '<denite:toggle_select_down>', 'noremap'],
            \ ['<C-t>', '<denite:move_to_first_line>', 'noremap'],
            \ ['<C-b>', '<denite:move_to_last_line>', 'noremap'],
            \ ['st', '<denite:do_action:tabopen>', 'noremap'],
            \ ['sh', '<denite:do_action:vsplit>', 'noremap'],
            \ ['sv', '<denite:do_action:split>', 'noremap'],
            \ ]

    for s:m in s:insert_mode_mappings
        call denite#custom#map('insert', s:m[0], s:m[1], s:m[2])
    endfor
    for s:m in s:normal_mode_mappings
        call denite#custom#map('normal', s:m[0], s:m[1], s:m[2])
    endfor

    unlet s:m s:insert_mode_mappings s:normal_mode_mappings
endif
"}}}

if (s:findplug('vim-choosewin') != -1)
    nmap - <Plug>(choosewin)
endif

if (s:findplug('vim-bookmarks') != -1)
    nmap <Leader>m <Plug>BookmarkToggle
    nmap <Leader>mi <Plug>BookmarkAnnotate
    nmap <Leader>ma <Plug>BookmarkShowAll
    nmap <Leader>mj <Plug>BookmarkNext
    nmap <Leader>mk <Plug>BookmarkPrev
    nmap <Leader>mc <Plug>BookmarkClear
    nmap <Leader>mx <Plug>BookmarkClearAll
endif

if (s:findplug('vim-ref') != -1)
    let g:ref_source_webdict_sites = {
          \   'je': {
          \     'url': 'http://dictionary.infoseek.ne.jp/jeword/%s',
          \   },
          \   'ej': {
          \     'url': 'http://dictionary.infoseek.ne.jp/ejword/%s',
          \   },
          \   'wiki': {
          \     'url': 'http://ja.wikipedia.org/wiki/%s',
          \   },
          \   'cn': {
          \     'url': 'http://www.iciba.com/%s',
          \   },
          \   'wikipedia:en':{'url': 'http://en.wikipedia.org/wiki/%s',  },
          \   'bing':{'url': 'http://cn.bing.com/search?q=%s', },
          \ }
    let g:ref_source_webdict_sites.default = 'cn'
    "let g:ref_source_webdict_cmd='lynx -dump -nonumbers %s'
    "let g:ref_source_webdict_cmd='w3m -dump %s'
    "The filter on the output. Remove the first few lines
    function! g:ref_source_webdict_sites.je.filter(output)
      return join(split(a:output, "\n")[15 :], "\n")
    endfunction
    function! g:ref_source_webdict_sites.ej.filter(output)
      return join(split(a:output, "\n")[15 :], "\n")
    endfunction
    function! g:ref_source_webdict_sites.wiki.filter(output)
      return join(split(a:output, "\n")[17 :], "\n")
    endfunction
    nnoremap <Leader>rj :<C-u>Ref webdict je<Space>
    nnoremap <Leader>re :<C-u>Ref webdict ej<Space>
    nnoremap <Leader>rc :<C-u>Ref webdict cn<Space>
    nnoremap <Leader>rw :<C-u>Ref webdict wikipedia:en<Space>
    nnoremap <Leader>rb :<C-u>Ref webdict bing<Space>
endif

if (s:findplug('fencview') != -1)
    let g:fencview_autodetect = 1
    let g:fencview_checklines = 10
endif

if (s:findplug('gocode') != -1)
    "start gocode first
    function! s:fcy_CallGocode()
        if !exists('g:startGocode')
            call vimproc#system_bg('gocode')
            let g:startGocode = 1
        endif
    endfunction
    autocmd! VimEnter *.go call s:fcy_CallGocode()

    "let g:gocomplete#system_function = 'vimproc#system'
    let g:godef_split=0
    let g:godef_same_file_in_same_window=1
endif

if (s:findplug('nerdcommenter') != -1)
    let g:NERDCreateDefaultMappings = 0
    let g:NERDRemoveExtraSpaces = 1
    let g:NERDDefaultAlign = 'left'
    let g:NERDCustomDelimiters = {
                \ 'c': { 'leftAlt': '/*', 'rightAlt': '*/', 'left': '//' },
                \ 'cpp': { 'leftAlt': '/*', 'rightAlt': '*/', 'left': '//' },
                \ 'go': { 'leftAlt': '/*', 'rightAlt': '*/', 'left': '//' },
                \ 'qml': { 'leftAlt': '/*', 'rightAlt': '*/', 'left': '//' },
                \ 'conf': { 'leftAlt': '/*', 'rightAlt': '*/', 'left': '#' },
                \ }
    nmap <A-/> <plug>NERDCommenterToggle
    vmap <A-/> <plug>NERDCommenterToggle gv
    nmap <leader>cc <plug>NERDCommenterToggle
    vmap <leader>cc <plug>NERDCommenterToggle gv
endif

if (s:findplug('tagbar') != -1) "{{{
    let tagbar_left=1
    nnoremap <silent><Leader>tt :TagbarToggle<CR>
    nnoremap <silent><F11> :TagbarToggle<CR>
    let tagbar_width=32
    let g:tagbar_compact=1
    "autocmd FileType c,cpp,h nested :TagbarOpen
    let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
    \ }
endif
"}}}

if (s:findplug('vim-bbye') != -1)
    :nnoremap <Leader>q :Bdelete<CR>
endif

if (s:findplug('vim-easymotion') != -1)
    let g:EasyMotion_smartcase = 0
    let g:EasyMotion_do_mapping = 0 " Disable default mappings
    nmap <leader>jj <Plug>(easymotion-s)
    nmap <leader>jJ <Plug>(easymotion-s2)
    nmap <leader>jl <Plug>(easymotion-bd-jk)
    nmap <leader>jw <Plug>(easymotion-bd-w)
endif

if (s:findplug('vim-fswitch') != -1)
    map <silent> <Leader>h <ESC>:FSHere<CR>
endif

if (s:findplug('vimshell') != -1)
    nnoremap <leader>vs :silent VimShell<CR>
    let g:vimshell_prompt_expr =
        \ 'escape(fnamemodify(getcwd(), ":~").">", "\\[]()?! ")." "'
    let g:vimshell_prompt_pattern = '^\%(\f\|\\.\)\+> '
    let g:vimshell_no_default_keymappings=0
endif

if (s:findplug('vim-AHKcomplete') != -1)
    " Enable omni completion.
    autocmd FileType autohotkey setl omnifunc=ahkcomplete#Complete
endif

"}}}
