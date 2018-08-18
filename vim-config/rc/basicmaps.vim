"Saving, autosaving toggle
let g:auto_save = 1  " enable AutoSave on Vim startup
let g:auto_save_silent = 1

nnoremap <F11>as :let g:auto_save=!g:auto_save <bar> echo 'autosave is '.g:auto_save<CR>

" bbye

" Undotree:
nnoremap <F10>uu :UndotreeToggle<CR>

" Tagbar:
nnoremap <F10>tg :TagbarToggle<CR>



" ====== DEV MAPS
" Show messages
nnoremap <Leader><Leader>d :messages<CR>
" visit vim rc file
nnoremap <Leader>gvrc yi':new <C-R>=g:vimrcdir<CR>/"
" resource vimrc
nnoremap <F10>vrc :source $MYVIMRC<CR>
nnoremap <F10>vrrc :w <bar> source $MYVIMRC<CR>
nnoremap <F10>evrc :e $MYVIMRC<CR>
nnoremap <F10>evvrc <C-w>v:e $MYVIMRC<CR>
nnoremap <F10>elvrc :LocalVimRCEdit<CR>
nnoremap <F10>lvrc :LocalVimRC<CR>


" Redo last cmd
nnoremap <Leader>. :<C-p><CR>

nnoremap <F11>w :setl wrap!<CR>
"cedit mode
nnoremap <C-f> :<C-f>
nnoremap <C-f>f :<C-f>i
nnoremap <C-f>p :<C-f>p
nnoremap <C-f><Space> :<C-f><Up><C-c><C-f>
