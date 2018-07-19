
nnoremap <silent> <Leader><F8> :ArgWrap<CR>
" More Arguments:
nnoremap <Leader><S-F8> :setlocal g:argumentobject_force_toplevel!
nnoremap <S-F8> :SidewaysLeft<CR>
nnoremap <S-F9> :SidewaysRight<CR>
nnoremap <F8> :SidewaysJumpLeft<CR>
nnoremap <F9> :SidewaysJumpRight<CR>
"Try it:
" fun(1, 2+3+4, bla(3, 4+4), 5, )

" Splitjoin:
let g:splitjoin_split_mapping = ''
let g:splitjoin_join_mapping = ''
nmap <Leader>kk :SplitjoinJoin<cr>
nmap <Leader>jj :SplitjoinSplit<cr>

