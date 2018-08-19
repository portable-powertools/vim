
nnoremap <silent> <Leader><F8> :ArgWrap<CR>
" More Arguments:

let g:argumentobject_force_toplevel = 0
nnoremap <F11>argtop :let g:argumentobject_force_toplevel = ! g:argumentobject_force_toplevel <bar> echo 'g:argumentobject_force_toplevel toggled to: '.g:argumentobject_force_toplevel<CR>

nnoremap <S-F8> :SidewaysLeft<CR>
nnoremap <S-F9> :SidewaysRight<CR>
nnoremap <F8> :SidewaysJumpLeft<CR>
nnoremap <F9> :SidewaysJumpRight<CR>
"Try it:
" fun(1, 2+3+4, bla(3, 4+4), 5, )

" Splitjoin:
let g:splitjoin_split_mapping = ''
let g:splitjoin_join_mapping = ''
nmap <F10>sj :SplitjoinJoin<cr>
nmap <F10>sp :SplitjoinSplit<cr>
imap <F10>sj <C-o>:SplitjoinJoin<cr>
imap <F10>sp <C-o>:SplitjoinSplit<cr>

