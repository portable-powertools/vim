nnoremap <Leader><Leader><Leader>l :call g:MoveToNextTab()<CR>
nnoremap <Leader><Leader><Leader>h :call g:MoveToPrevTab()<CR>
nmap <Leader><Leader><Leader>L :sp<CR>:call g:MoveToNextTab()<CR>
nmap <Leader><Leader><Leader>H :sp<CR>:call g:MoveToPrevTab()<CR>

" =========== works 

cnoremap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

" undo :q
let g:undoquit_mapping = '<C-w>u'
map <Leader><Leader>u <C-w>u
let g:tradewinds_no_maps = 1

" window movement
" swapping
nmap <Leader><Leader>j <C-w>j<C-w>:call g:WinBufSwap()<CR>
nmap <Leader><Leader>k <C-w>k<C-w>:call g:WinBufSwap()<CR>
nmap <Leader><Leader>l <C-w>l<C-w>:call g:WinBufSwap()<CR>
nmap <Leader><Leader>h <C-w>h<C-w>:call g:WinBufSwap()<CR>
" soft move (tradewinds plugin)
nmap <leader><Leader>H <plug>(tradewinds-h)
nmap <leader><Leader>J <plug>(tradewinds-j)
nmap <leader><Leader>K <plug>(tradewinds-k)
nmap <leader><Leader>L <plug>(tradewinds-l)
" simply splitting the same buffer in the 4 directions (2 dir + stay or move)
nmap <Leader>j :sp<CR>
nmap <Leader>k :sp<CR><C-w>k
nmap <Leader>l :vs<CR>
nmap <Leader>h :vs<CR><C-w>h
" -- and deleting in 4 directions
nmap <Leader>H <C-w>h:q<CR><C-w>p
nmap <Leader>J <C-w>j:q<CR><C-w>p
nmap <Leader>K <C-w>k:q<CR><C-w>p
nmap <Leader>L <C-w>l:q<CR><C-w>p
    tmap <Leader><Leader>j <C-w>j<C-w>:call g:WinBufSwap()<CR>
    tmap <Leader><Leader>k <C-w>k<C-w>:call g:WinBufSwap()<CR>
    tmap <Leader><Leader>l <C-w>l<C-w>:call g:WinBufSwap()<CR>
    tmap <Leader><Leader>h <C-w>h<C-w>:call g:WinBufSwap()<CR>
    tmap <leader><Leader>H <C-w>N<plug>(tradewinds-h)i
    tmap <leader><Leader>J <C-w>N<plug>(tradewinds-j)i
    tmap <leader><Leader>K <C-w>N<plug>(tradewinds-k)i
    tmap <leader><Leader>L <C-w>N<plug>(tradewinds-l)i
    " tmap <Leader>j <C-w>:sp<CR>
    " tmap <Leader>k <C-w>:sp<CR><C-w>k
    " tmap <Leader>l <C-w>:vs<CR>
    " tmap <Leader>h <C-w>:vs<CR><C-w>h
    tmap <Leader>H <C-w>h<C-w>:q<CR><C-w>p
    tmap <Leader>J <C-w>j<C-w>:q<CR><C-w>p
    tmap <Leader>K <C-w>k<C-w>:q<CR><C-w>p
    tmap <Leader>L <C-w>l<C-w>:q<CR><C-w>p

command! -nargs=0 ResetCWD exec 'cd '.getcwd(-1)
nmap <Leader>n :enew<CR>
nmap <Leader>N :enew<CR>:ResetCWD<CR>:pwd<CR>
nmap <Leader>d? :echom 'pwd: '.getcwd().' <bar> -1wd: ' . getcwd(-1)<CR>
nmap <Leader>gcd :ResetCWD<CR>:pwd<CR>

" ,BufWinEnter,TabEnter
augroup cdprint
    au!
    autocmd WinEnter,TabEnter * call g:PwdEcho()
augroup end
let g:monitorPwd=0
nnoremap <F11>dir :let g:monitorPwd = ! g:monitorPwd <bar> echo 'g:monitorPwd toggled to: '.g:monitorPwd<CR>
fun! g:PwdEcho()
    if g:monitorPwd
        echom 'pwd: '.getcwd().' | -1wd: ' . getcwd(-1)
    endif
endf

nmap <Leader>x :q<CR>
nmap <Leader>X :q!<CR>

nmap <F10>x :bdelete<CR><C-w>p
nmap <F10>X :bdelete!<CR><C-w>p
nmap <F10><F10>x :Bdelete<CR>
nmap <F10><F10>X :Bdelete!<CR>

" Choosewin -- mostly terminal compat
nmap  <C-w>w  <Plug>(choosewin)
tnoremap  <C-w>w  <C-w>:ChooseWin<CR>
tnoremap <C-w>x  <C-w>:q!<CR>
let g:choosewin_overlay_enable = 0

" Resize
nnoremap <silent> <c-left> :CmdResizeLeft<cr>
nnoremap <silent> <c-down> :CmdResizeDown<cr>
nnoremap <silent> <c-up> :CmdResizeUp<cr>
nnoremap <silent> <c-right> :CmdResizeRight<cr>


function! g:WinBufSwap()
  let thiswin = winnr()
  let thisbuf = bufnr("%")
  let lastwin = winnr("#")
  let lastbuf = winbufnr(lastwin)

  exec  lastwin . " wincmd w" ."|".
      \ "buffer ". thisbuf ."|".
      \ thiswin ." wincmd w" ."|".
      \ "buffer ". lastbuf
endfunction


function! g:MoveToPrevTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() != 1
    close!
    if l:tab_nr == tabpagenr('$')
      tabprev
    endif
    sp
  else
    close!
    exe "0tabnew"
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunc

function! g:MoveToNextTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() < tab_nr
    close!
    if l:tab_nr == tabpagenr('$')
      tabnext
    endif
    sp
  else
    close!
    tabnew
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunc
