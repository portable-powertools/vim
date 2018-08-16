" substitute forward
map <F3>s$ :.,$&gc<CR>
map <F3>S$ :.,$&g<CR>
map <F3>n n&

vnoremap <silent> <F3>f :<C-U>call <SID>VSetSearch('/')<CR>/<C-R>/<CR><C-o>
vnoremap <silent> * :<C-U>call <SID>VSetSearch('/')<CR>/<C-R>/<CR><C-o>
nmap <Plug>VLToggle :let g:VeryLiteral = !g:VeryLiteral
  \\| echo "VeryLiteral " . (g:VeryLiteral ? "On" : "Off")<CR>
nmap <F11>vl <Plug>VLToggle 
inoremap <silent> <C-R>/ <C-R>=Del_word_delims()<CR>
cnoremap <C-R>/ <C-R>=Del_word_delims()<CR>

" set gdefault
nnoremap <Leader>g& :%s//~/&c<CR>
command! -nargs=* SP call g:Simleime_fetch(<q-args>."\n")

" single s: identical replacement, double: no replacement, triple: unnamed reg. replacement
vnoremap <F3>s" :s/\V<C-r>"/<C-r>"/<Left>
vnoremap <F3>sw "zy:s/\V<C-r>z/<C-r>z/<Left>
vnoremap <F3>ss" :s/\V<C-r>"//<Left>
vnoremap <F3>ssw "zy:s/\V<C-r>z//<Left>
vnoremap <F3>sss" :s/\V<C-r>"/<C-r>"/<Left>
vnoremap <F3>sssw "zy:s/\V<C-r>z/<C-r>0/<Left>

nnoremap <F3>s" :s/\V<C-r>"/<C-r>"/<Left>
nnoremap <F3>sw :s/\V<C-r><C-w>/<C-r><C-w>/<Left>
nnoremap <F3>sW "zyiW:s/\V<C-r>z/<C-r>z/<Left>
nnoremap <F3>ss" :s/\V<C-r>"//<Left>
nnoremap <F3>ssw :s/\V<C-r><C-w>//<Left>
nnoremap <F3>ssW "zyiW:s/\V<C-r>z//<Left>
nnoremap <F3>sssw :s/\V<C-r><C-w>/<C-r>"/<Left>
nnoremap <F3>sssW "zyiW:s/\V<C-r>z/<C-r>0/<Left>

nnoremap <F3>/p mzygn`zp<C-R>0
inoremap <F3>/p <Esc>ygngi<C-R>0

nmap <F3>/l /.*<C-r>/.*<Left><Left><CR>

nnoremap <Leader>/y :execute 'CopyMatches '.v:register<CR>
nnoremap <Leader>/s :CopyMatches -<CR>


" Plugin to copy matches (search hits which may be multiline).
" Version 2012-05-03 from http://vim.wikia.com/wiki/VimTip478
"
" :CopyMatches      copy matches to clipboard (each match has newline added)
" :CopyMatches x    copy matches to register x
" :CopyMatches X    append matches to register x
" :CopyMatches -    display matches in a scratch buffer (does not copy)
" :CopyMatches pat  (after any of above options) use 'pat' as search pattern
" :CopyMatches!     (with any of above options) insert line numbers
" Same options work with the :CopyLines command (which copies whole lines).

" Jump to first scratch window visible in current tab, or create it.
" This is useful to accumulate results from successive operations.
" Global function that can be called from other scripts.
function! GoScratch()
  let done = 0
  for i in range(1, winnr('$'))
    execute i . 'wincmd w'
    if &buftype == 'nofile'
      let done = 1
      break
    endif
  endfor
  if !done
    new
    setlocal buftype=nofile bufhidden=hide noswapfile
  endif
endfunction

" Append match, with line number as prefix if wanted.
function! s:Matcher(hits, match, linenums, subline)
  if !empty(a:match)
    let prefix = a:linenums ? printf('%3d  ', a:subline) : ''
    call add(a:hits, prefix . a:match)
  endif
  return a:match
endfunction

" Append line numbers for lines in match to given list.
function! s:MatchLineNums(numlist, match)
  let newlinecount = len(substitute(a:match, '\n\@!.', '', 'g'))
  if a:match =~ "\n$"
    let newlinecount -= 1  " do not copy next line after newline
  endif
  call extend(a:numlist, range(line('.'), line('.') + newlinecount))
  return a:match
endfunction

" Return list of matches for given pattern in given range.
" If 'wholelines' is 1, whole lines containing a match are returned.
" This works with multiline matches.
" Work on a copy of buffer so unforeseen problems don't change it.
" Global function that can be called from other scripts.
function! GetMatches(line1, line2, pattern, wholelines, linenums)
  let savelz = &lazyredraw
  set lazyredraw
  let lines = getline(1, line('$'))
  new
  setlocal buftype=nofile bufhidden=delete noswapfile
  silent put =lines
  1d
  let hits = []
  let sub = a:line1 . ',' . a:line2 . 's/' . escape(a:pattern, '/')
  if a:wholelines
    let numlist = []  " numbers of lines containing a match
    let rep = '/\=s:MatchLineNums(numlist, submatch(0))/e'
  else
    let rep = '/\=s:Matcher(hits, submatch(0), a:linenums, line("."))/e'
  endif
  silent execute sub . rep . (&gdefault ? '' : 'g')
  close
  if a:wholelines
    let last = 0  " number of last copied line, to skip duplicates
    for lnum in numlist
      if lnum > last
        let last = lnum
        let prefix = a:linenums ? printf('%3d  ', lnum) : ''
        call add(hits, prefix . getline(lnum))
      endif
    endfor
  endif
  let &lazyredraw = savelz
  return hits
endfunction

" Copy search matches to a register or a scratch buffer.
" If 'wholelines' is 1, whole lines containing a match are returned.
" Works with multiline matches. Works with a range (default is whole file).
" Search pattern is given in argument, or is the last-used search pattern.
function! s:CopyMatches(bang, line1, line2, args, wholelines)
  let l = matchlist(a:args, '^\%(\([a-zA-Z"*+-]\)\%($\|\s\+\)\)\?\(.*\)')
  let reg = empty(l[1]) ? '+' : l[1]
  let pattern = empty(l[2]) ? @/ : l[2]
  let hits = GetMatches(a:line1, a:line2, pattern, a:wholelines, a:bang)
  let msg = 'No non-empty matches'
  if !empty(hits)
    if reg == '-'
      call GoScratch()
      normal! G0m'
      silent put =hits
      " Jump to first line of hits and scroll to middle.
      ''+1normal! zz
    else
      execute 'let @' . reg . ' = join(hits, "\n") . "\n"'
    endif
    let msg = 'Number of matches: ' . len(hits)
  endif
  redraw  " so message is seen
  echo msg
endfunction
command! -bang -nargs=? -range=% CopyMatches call s:CopyMatches(<bang>0, <line1>, <line2>, <q-args>, 0)
command! -bang -nargs=? -range=% CopyLines call s:CopyMatches(<bang>0, <line1>, <line2>, <q-args>, 1)

" =========== VeryLiteral visual search functions

if !exists('g:VeryLiteral')
  let g:VeryLiteral = 0
endif
function! s:VSetSearch(cmd)
  let old_reg = getreg('"')
  let old_regtype = getregtype('"')
  normal! gvy
  if @@ =~? '^[0-9a-z,_]*$' || @@ =~? '^[0-9a-z ,_]*$' && g:VeryLiteral
    let @/ = @@
  else
    let pat = escape(@@, a:cmd.'\')
    if g:VeryLiteral
      let pat = substitute(pat, '\n', '\\n', 'g')
    else
      let pat = substitute(pat, '^\_s\+', '\\s\\+', '')
      let pat = substitute(pat, '\_s\+$', '\\s\\*', '')
      let pat = substitute(pat, '\_s\+', '\\_s\\+', 'g')
    endif
    let @/ = '\V'.pat
  endif
  normal! gV
  call setreg('"', old_reg, old_regtype)
endfunction

function! Del_word_delims()
   let reg = getreg('/')
   " After *                i^r/ will give me pattern instead of \<pattern\>
   let res = substitute(reg, '^\\<\(.*\)\\>$', '\1', '' )
   if res != reg
      return res
   endif
   " After * on a selection i^r/ will give me pattern instead of \Vpattern
   let res = substitute(reg, '^\\V'          , ''  , '' )
   let res = substitute(res, '\\\\'          , '\\', 'g')
   let res = substitute(res, '\\n'           , '\n', 'g')
   return res
endfunction
