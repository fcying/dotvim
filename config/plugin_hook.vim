function! BuildVimproc(info)
    " info is a dictionary with 3 fields
    " - name:   name of the plugin
    " - status: 'installed', 'updated', or 'unchanged'
    " - force:  set on PlugInstall! or PlugUpdate!
    if a:info.status != 'unchanged' || a:info.force
        if g:os_windows
            silent !Tools\update-dll-mingw.bat
        else
            silent !make
        endif
    endif
endfunction

function! GetGoCode(info)
    if a:info.status != 'unchanged' || a:info.force
        if executable('go')
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
                silent !gocode set lib-path $GOPATH/pkg/linux_386
            endif
        endif
  endif
endfunction

