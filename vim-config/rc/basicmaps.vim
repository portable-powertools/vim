"Saving, autosaving toggle
let g:auto_save = 1  " enable AutoSave on Vim startup
let g:auto_save_silent = 1

nnoremap <F11>as :let g:auto_save=!g:auto_save <bar> echo 'autosave is '.g:auto_save<CR>

" bbye

" Undotree:
nnoremap <F10>uu :UndotreeToggle<CR>


" ====== DEV MAPS
" visit vim rc file
nnoremap <Leader>gvrc yi':new <C-R>=g:vimrcdir<CR>/"

" edit and resource vimrc
nnoremap <F10>rcev :sp<CR>:e $MYVIMRC<CR>
nnoremap <F10>rcel :LocalVimRCEdit<CR>

nmap <F10>rcv :source $MYVIMRC<CR>
nmap <F10>rcl :LocalVimRC<CR>


" Redo last cmd
nnoremap <Leader><Leader>. :<C-p><CR>

nnoremap <F11>w :setl wrap!<CR>


"cedit mode
" nnoremap <C-f> :<C-f>
" nnoremap <C-f>f :<C-f>i
" nnoremap <C-f>p :<C-f>p
" nnoremap <C-f><Space> :<C-f><Up><C-c><C-f>
