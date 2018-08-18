" window movement
" swapping
nmap <Leader><Leader>j <C-w>j:call g:WinBufSwap()<CR>
nmap <Leader><Leader>k <C-w>k:call g:WinBufSwap()<CR>
nmap <Leader><Leader>l <C-w>l:call g:WinBufSwap()<CR>
nmap <Leader><Leader>h <C-w>h:call g:WinBufSwap()<CR>
" soft move (tradewinds plugin)
let g:tradewinds_no_maps = 1
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

nmap <Leader>n :enew<CR>

nmap <Leader>x :q<CR>
nmap <Leader>!x :q!<CR>
nmap <Leader>X :qa<CR>
nmap <Leader>!X :qa!<CR>
nmap <Leader><Leader>X :qa!<CR>


nmap <F10>x :bdelete<CR>
nmap <F10>X :Bdelete<CR>
nmap <F10>!x :bdelete!<CR>
nmap <F10>!X :Bdelete!<CR>

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
