function! fpc#init() abort
  let g:fpc_custom_matcher = get(g:, 'fpc_custom_matcher', 0)
  let g:fpc_min_match_len = get(g:, 'fpc_min_match_len', 2)
  let g:fpc_max_keyword_len = get(g:, 'fpc_max_keyword_len', 100)
  let g:fpc_max_matches = get(g:, 'fpc_max_matches', 50)
  let g:fpc_max_file_size = get(g:, 'fpc_max_file_size', 1000000)  " 1mb
  let g:fpc_use_all_buffers = get(g:, 'fpc_use_all_buffers', 1)
  let g:fpc_use_cache = get(g:, 'fpc_use_cache', 1)
  let g:fpc_force_refresh_menu = get(g:, 'fpc_force_refresh_menu', 1)
  let g:fpc_omni_enabled_ft = get(g:, 'fpc_omni_enabled_ft', {'python': 1, 'javascript': 1, 'c':1})

  let s:FuzzyFunc = g:fpc_custom_matcher || !exists('*matchfuzzy') ? function('s:FuzzyMatch') : function('s:VimFuzzyMatch')
  let s:disable_once = 0
  let s:omni_info = {'on': 0}  " builtin omni or path completion information

  set omnifunc=syntaxcomplete#Complete
  set completeopt=menuone
  set shortmess+=c
  inoremap <expr> <Tab> pumvisible() ? '<C-n>' : '<Tab>'
  inoremap <expr> <S-Tab> pumvisible() ? '<C-p>' : '<S-Tab>'
  inoremap <expr> <CR> pumvisible() ? fpc#accept() : '<CR>'
  inoremap <expr> <BS> pumvisible() ? '<C-y><BS>' : '<BS>'
  inoremap <expr> <C-@> fpc#refresh()
  inoremap <expr> <C-Space> fpc#refresh()

  augroup FpcInit
    autocmd!
    autocmd BufEnter,TabEnter * call s:OnBufEnter()
    autocmd FileType * let b:fpc_omni_enabled = get(g:fpc_omni_enabled_ft, &filetype, 0)
  augroup END
endfunction

function! s:OnBufEnter() abort
  let s:prev_base = '-'
  let s:prev_base_start = -1
  let s:prev_line = -1
  let s:omni_info.on = 0

  if exists('b:loaded_fpc')
    return
  endif
  let b:loaded_fpc = 1

  if (&buftype != '' && &buftype != 'nofile') || getfsize(expand(@%)) > g:fpc_max_file_size
    return
  endif

  let b:fpc_omni_enabled = get(g:fpc_omni_enabled_ft, &filetype, 0)
  let b:fpc_words_dict = {}
  call s:RefreshBufWords({'type': 0})
  augroup FpcEvents
    autocmd! * <buffer>
    autocmd TextChangedI <buffer> call s:DoCompletion()
    if g:fpc_use_cache == 0
      autocmd BufLeave <buffer> call s:RefreshBufWords({'type': 0})
    endif
    if g:fpc_force_refresh_menu
      autocmd InsertCharPre <buffer> if pumvisible() && !s:omni_info.on | call feedkeys("\<C-e>", 'in') | endif
    endif
  augroup END
endfunction

function! fpc#accept()
  let s:disable_once = !s:omni_info.on
  return "\<C-y>"
endfunction

function! fpc#refresh()
  let s:prev_base = '-'
  let s:prev_base_start = -1
  let s:prev_line = -1

  if &buftype == 'nofile'  " refresh scratch buffer if focused
    call s:RefreshBufWords({'type': 2, 'bufnr': bufnr('%')})
  endif
  for bufnr in filter(range(1, bufnr('$')), 'buflisted(v:val) && bufloaded(v:val)')
    call s:RefreshBufWords({'type': 2, 'bufnr': bufnr})
  endfor
  return pumvisible() ? "\<C-y>" : " \<BS>"
endfunction

function! s:DoCompletion() abort
  if s:disable_once
    let s:disable_once = 0
    return
  endif

  let line_content = getline('.')
  let line = line('.')
  let col = col('.')

  if !s:omni_info.on || s:omni_info.col != col || s:omni_info.line != line
    let last_char = line_content[col - 2]
    if last_char == '/' && line_content[match(line_content, '\S\+\%'. col. 'c')] =~ '\W'
      let s:omni_info = {'on': 1, 'line': line, 'col': col}
      call feedkeys("\<C-x>\<C-f>\<C-p>", 'in')
      return
    elseif b:fpc_omni_enabled && last_char == '.'
      let s:omni_info = {'on': 1, 'line': line, 'col': col}
      call feedkeys("\<C-x>\<C-o>\<C-p>", 'in')
      return
    endif
  endif
  let s:omni_info.on = 0

  let base_start = match(line_content, '\w\+\%'. col. 'c')
  let col_index = col - 2
  let base = line_content[base_start : col_index]
  if len(base) < g:fpc_min_match_len
    return
  endif

  if s:prev_base_start != base_start || s:prev_line != line
    call s:RefreshBufWords({'type': g:fpc_use_cache, 'line': line, 'col': base_start - 2})
    let s:prev_line = line
    let s:prev_base_start = base_start
    let s:prev_base = '-'  " reset s:prev_base to disable cache on next match because word list is refreshed
  endif

  let s:match_list = s:FuzzyFunc(base)
  if len(s:match_list) > 0
    call complete(base_start + 1, s:match_list)
    call feedkeys("\<C-p>", 'in')
  endif
endfunction

function! s:RefreshBufWords(options) abort  " {'type': 0 = refresh current buffer, 1 = refresh incrementally while typing, 2 = manual refresh}
  let bufnr = get(a:options, 'bufnr', bufnr('%'))
  let words_dict = a:options.type == 1 ? b:fpc_words_dict : {}

  if a:options.type == 1  " refresh incrementally
    if s:prev_line == a:options.line
      let curr_line = getline('.')
      let base_end = match(curr_line, '\W', col('.'))
      let buf_string = curr_line[:a:options.col]. (base_end >= 0 ? curr_line[base_end :] : '')
    elseif s:prev_line < a:options.line
      let buf_string = join(getline(s:prev_line, a:options.line), "\n")
    else  " editing text above, add a few more lines down in case new lines are added above
      let buf_string = join(getline(a:options.line, s:prev_line + 10), "\n")
    endif
  elseif a:options.type == 0 || bufnr != bufnr('%')  " refresh all words in current or another buffer
    let buf_string = join(getbufline(bufnr, 1, '$'), "\n")
  else  " refresh current buffer except current word base (triggered manually)
    let lines = getline(1, '$')
    let line_index = line('.') - 1
    let col = col('.')
    let curr_line = lines[line_index]
    let base_start = match(curr_line, '\w\+\%'. col. 'c')
    let base_end = match(curr_line, '\W', col)
    let lines[line_index] = curr_line[:base_start]. curr_line[base_end :]
    let buf_string = join(lines, "\n")
  endif

  for word in filter(split(buf_string, '\W\+\d*\|^\d'), 'len(v:val) > g:fpc_min_match_len && len(v:val) < g:fpc_max_keyword_len')
    let words_dict[word] = 1
  endfor
  call setbufvar(bufnr, 'fpc_words_dict', words_dict)
endfunction

function! s:GetWordsList(f) abort
  let all_words = a:f != '' ? filter(keys(b:fpc_words_dict), 'v:val =~ a:f') : keys(b:fpc_words_dict)
  if g:fpc_use_all_buffers == 0
    return all_words
  endif

  let s:curr_bwords_len = len(all_words)  " s:curr_bwords_len > 0 && all_words[:s:curr_bwords_len-1] will be words in current buffer
  let curr_buf = bufnr('%')
  for bufnr in filter(range(1, bufnr('$')), 'bufloaded(v:val) && v:val != curr_buf')
    let buf_words_dict = getbufvar(bufnr, 'fpc_words_dict', {})
    if len(buf_words_dict) > 0 && len(buf_words_dict) < 20000
      call extend(all_words, a:f != '' ? filter(keys(buf_words_dict), 'v:val =~ a:f') : keys(buf_words_dict))
    endif
  endfor
  return all_words
endfunction

function! s:FuzzyMatch(base) abort
  let base_arr = split(a:base, '\zs')
  let f = join(base_arr, '\w*')  " regex to filter out unmatched words
  let r = join(base_arr, '\w\{-}')  " regex to find matched rank
  let words = a:base =~ '^'. s:prev_base ? s:prev_list : s:GetWordsList(f)

  if len(a:base) == g:fpc_min_match_len  " save word list if filtered with smallest base
    let s:prev_list = words
    let s:prev_base = a:base
    let curr_buf_words = s:curr_bwords_len == 0 ? [] : words[:s:curr_bwords_len-1]
    let other_buf_words = words[s:curr_bwords_len :]
  else  " base different from cache, filter now for better performance (won't change words because slice copies)
    let curr_buf_words = s:curr_bwords_len == 0 ? [] : filter(words[:s:curr_bwords_len-1], 'v:val =~ f')
    let other_buf_words = filter(words[s:curr_bwords_len :], 'v:val =~ f')
  endif

  let result = map(curr_buf_words, '{"word": v:val, "kind": "[ID]", "r": matchend(v:val, r)}')
  call extend(result, map(other_buf_words, '{"word": v:val, "kind": "[Buffer]", "r": 2 * matchend(v:val, r)}'))
  " return sort(result, {i1, i2 -> i1.r > i2.r ? 1 : -1})[:g:fpc_max_matches]  " lambda compare in this order is faster than Funcref
  return sort(result, function('s:CompareTo'))[:g:fpc_max_matches]
endfunction

function! s:CompareTo(i1, i2)
  return a:i1.r > a:i2.r ? 1 : -1
endfunction

function! s:VimFuzzyMatch(base) abort
  return map(matchfuzzy(s:GetWordsList(''), a:base)[:g:fpc_max_matches], '{"word": v:val, "kind": "[ID]"}')
endfunction
