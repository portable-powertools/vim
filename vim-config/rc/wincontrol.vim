
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

