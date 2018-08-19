" undo :q
let g:undoquit_mapping = '<C-w>u'
map <Leader><Leader>u <C-w>u

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
