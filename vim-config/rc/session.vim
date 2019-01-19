if has('persistent_undo')
    let &undodir = g:UnmanagedDataFolder('vim-undo')
    set undofile
endif
let g:session_directory = g:UnmanagedDataFolder('xolox-sessions')
execute "set viewdir=".g:UnmanagedDataFolder('viewdiropt-views')
set viewoptions=cursor,folds,slash,unix

let g:session_autoload = "no"
let g:session_autosave = "no"
let g:session_command_aliases = 1

let g:session_persist_font = 0
let g:session_persist_colors = 0

" let g:session_persist_globals = ['&sessionoptions']
" call add(g:session_persist_globals, 'g:session_persist_globals')

" Persistent variables:

nnoremap <F10>sso :SessionOpen<Space>
nnoremap <F10>sss :SessionSave<Space>
nnoremap <F10>SSO :SessionTabOpen<Space>
nnoremap <F10>SSS :SessionTabSave<Space>
nnoremap <F10>dhb :DeleteHiddenBuffers<CR>

let g:rooter_manual_only = 1
let g:rooter_use_lcd = 0
let g:rooter_patterns = ['.projectroot!', 'Rakefile', '.git/', '.projectroot']

" ---- Basic
" -- directory management
nnoremap <F10>dcd :cd %:p:h<CR>
" nnoremap <leader>lcd :lcd %:p:h<CR>
cnoremap <F10>d <C-R>=expand("%:p:h") . "/" <CR>

