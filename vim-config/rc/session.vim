if has('persistent_undo')
    let &undodir = g:UnmanagedDataFolder('vim-undo')
    set undofile
endif
let g:session_directory = g:UnmanagedDataFolder('xolox-sessions')
execute "set viewdir=".g:UnmanagedDataFolder('viewdiropt-views')
set viewoptions=cursor,folds,slash,unix

nnoremap <F11>cd; :let g:rooter_manual_only = !g:rooter_manual_only <bar> echo 'autoroot: '.!g:rooter_manual_only<CR>
nnoremap <F11>lcd; :let g:rooter_use_lcd = !g:rooter_use_lcd <bar> echo 'autoroot LCD: '.g:rooter_use_lcd<CR>
nnoremap <Leader>cdr :Rooter<CR>

let g:session_autoload = "no"
let g:session_autosave = "no"
let g:session_command_aliases = 1

let g:session_persist_font = 0
let g:session_persist_colors = 0

" Persistent variables:

let g:session_persist_globals = ['&sessionoptions']
call add(g:session_persist_globals, 'g:session_persist_globals')
call add(g:session_persist_globals, 'g:Simleime_targetTermBuf')
call add(g:session_persist_globals, 'g:Simleime_targetTermWin')

nnoremap <F10>sso :SessionOpen<Space>
nnoremap <F10>sss :SessionSave<Space>
nnoremap <F10>SSO :SessionTabOpen<Space>
nnoremap <F10>SSS :SessionTabSave<Space>
nnoremap <F10>dhb :DeleteHiddenBuffers<CR>

let g:rooter_manual_only = 1
let g:rooter_use_lcd = 0
let g:rooter_patterns = ['.projectroot!', 'Rakefile', '.git/', '.projectroot']

" Localvimrc:
"
let g:localvimrc_sandbox = 0
let g:localvimrc_ask = 0
let g:localvimrc_persistent = 1
let g:localvimrc_persistence_file = g:UnmanagedDataFolder('localvimrcpersistence')

" ---- Basic
" -- directory management
nnoremap <leader>cd :cd %:p:h<CR>
nnoremap <leader>lcd :lcd %:p:h<CR>
" noremap <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>
" noremap <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>
cnoremap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

