" undo :q
let g:undoquit_mapping = '<C-w>u'
map <Leader><Leader>u <C-w>u
let g:tradewinds_no_maps = 1

" window movement
" swapping
nmap <Leader><Leader>j <C-w>j:call g:WinBufSwap()<CR>
nmap <Leader><Leader>k <C-w>k:call g:WinBufSwap()<CR>
nmap <Leader><Leader>l <C-w>l:call g:WinBufSwap()<CR>
nmap <Leader><Leader>h <C-w>h:call g:WinBufSwap()<CR>
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
nmap <Leader>H <C-w>h:q<CR>
nmap <Leader>J <C-w>j:q<CR>
nmap <Leader>K <C-w>k:q<CR>
nmap <Leader>L <C-w>l:q<CR>
    tmap <Leader><Leader>j <C-w>j:call g:WinBufSwap()<CR>
    tmap <Leader><Leader>k <C-w>k:call g:WinBufSwap()<CR>
    tmap <Leader><Leader>l <C-w>l:call g:WinBufSwap()<CR>
    tmap <Leader><Leader>h <C-w>h:call g:WinBufSwap()<CR>
    tmap <leader><Leader>H <C-w>N<plug>(tradewinds-h)i
    tmap <leader><Leader>J <C-w>N<plug>(tradewinds-j)i
    tmap <leader><Leader>K <C-w>N<plug>(tradewinds-k)i
    tmap <leader><Leader>L <C-w>N<plug>(tradewinds-l)i
    " tmap <Leader>j <C-w>:sp<CR>
    " tmap <Leader>k <C-w>:sp<CR><C-w>k
    " tmap <Leader>l <C-w>:vs<CR>
    " tmap <Leader>h <C-w>:vs<CR><C-w>h
    " tmap <Leader>H <C-w>h:q<CR>
    " tmap <Leader>J <C-w>j:q<CR>
    " tmap <Leader>K <C-w>k:q<CR>
    " tmap <Leader>L <C-w>l:q<CR>

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
nmap <Leader>!x :q!<CR>
nmap <Leader>X :qa<CR>
nmap <Leader>!X :qa!<CR>
nmap <Leader><Leader>X :qa!<CR>


nmap <F10>x :bdelete<CR>
nmap <F10>X :Bdelete<CR>
nmap <F10>!x :bdelete!<CR>
nmap <F10>!X :Bdelete!<CR>




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
