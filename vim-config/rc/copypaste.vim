nnoremap <Leader>cs :let @"=@+<CR>
nnoremap <Leader>cv :let @+=@"<CR>

nnoremap <F10>ip :IPaste<CR>
inoremap <F10>ip <C-o>:IPaste<CR>
map ," "+

nnoremap <Del> "_x

" easyclip
let g:EasyClipUseCutDefaults = 0

nmap x <Plug>MoveMotionPlug
xmap x <Plug>MoveMotionXPlug
nmap xx <Plug>MoveMotionLinePlug
nmap X <Plug>MoveMotionEndOfLinePlug

let g:EasyClipShareYanksDirectory = g:UnmanagedDataFolder('easyClipShareYanks') " has its own var for specifying filename
let g:EasyClipShareYanks = 0 " TODO: reenable aeasyclip yank sharing as soon as issue is resolved.

" candidates for changing:
" g:EasyClipCopyExplicitRegisterToDefault -  Everytthing is copied also to the default clipboard by default. 
" g:EasyClipPreserveCursorPositionAfterYank - Default 0 (ie. disabled). Vim's default behaviour is to position the cursor at the beginning of the yanked text, which is consistent with other motions. However if you prefer the cursor position to remain unchanged when performing yanks, enable this option.

