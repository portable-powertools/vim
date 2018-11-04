
nnoremap <silent> <Leader><F8> :ArgWrap<CR>
" More Arguments:

let g:argumentobject_force_toplevel = 0
nnoremap <F11>argtop :let g:argumentobject_force_toplevel = ! g:argumentobject_force_toplevel <bar> echo 'g:argumentobject_force_toplevel toggled to: '.g:argumentobject_force_toplevel<CR>

" TODO: this is a VIMapping? :D
nnoremap <Space> :SidewaysJumpLeft<CR>
",<Down> is for easymotion
nnoremap <Leader><Right> m`:SidewaysJumpRight<CR>
nnoremap <Leader><Left> m`:SidewaysJumpLeft<CR>
nnoremap <Leader><Leader><Right> m`%:SidewaysJumpRight<CR>
nnoremap <Leader><Leader><Left> m`%:SidewaysJumpLeft<CR>
nnoremap <Leader><Leader><Leader><Right> m`:SidewaysRight<CR>
nnoremap <Leader><Leader><Leader><Left> m`:SidewaysLeft<CR>

nnoremap <Leader><Leader><Leader><Up> :SplitjoinSplit<CR>
nnoremap <Leader><Leader><Leader><Down> :SplitjoinJoin<CR>

"Try it:
" fun( 1, 2+3+4, bla(3, 4+4).abc, 5)
"     fun[ 1, 2+3 +4, bla[ 3, 4+ 4], 5]

" Splitjoin:
let g:splitjoin_split_mapping = ''
let g:splitjoin_join_mapping = ''


