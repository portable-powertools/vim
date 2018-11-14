" Plugin: Fastfold
" regarding simpylFold, auto-on-save interrupts vim-schlepp...
let g:fastfold_savehook = 0
let g:fastfold_fold_command_suffixes =  ['x','X']
let g:fastfold_fold_movement_commands = []

" Update fold mapping with revealing the current code, all else folded
nmap zuZ :FastFoldUpdate<CR>zM:sleep 200m<CR>zr:sleep 200m<CR>zvzz
nmap zuz :FastFoldUpdate<CR>

" This resets e.g. after SearchFold
let g:searchFoldMayResetToGlobal = 0

nmap zuu <Plug>SearchFoldRestorezuz
nmap <Leader>Z zR

" Plugin: Searchfold

fun! g:GetLocalSFStack()
    if !exists('b:lastSearchFold')
        let b:lastSearchFold = lh#stack#new()
        return b:lastSearchFold
    else
        return b:lastSearchFold
    endif
endf
fun! g:GetGlobalSFStack()
    if !exists('g:lastSearchFold')
        let g:lastSearchFold = lh#stack#new()
        return g:lastSearchFold
    else
        return g:lastSearchFold
    endif
endf
fun! g:PushSearchFoldPattern()
    if GetLocalSFStack().top_or('__empty') != getreg('/')
        call g:GetLocalSFStack().push(getreg('/'))
    endif
    if GetGlobalSFStack().top_or('__empty') != getreg('/')
        call g:GetGlobalSFStack().push(getreg('/'))
    endif
endf
command! -nargs=0 SFSG echom '[ '.join(g:GetGlobalSFStack().values, ' | ').' ]'
command! -nargs=0 SFSL echom '[ '.join(g:GetLocalSFStack().values, ' | ').' ]'

fun! g:PopSearchFoldPattern(apply, ...)
    let l:global = get(a:, 1, '0')
    call xolox#misc#msg#info('stackglobal: '.l:global)
    if l:global
        let l:stack = g:GetGlobalSFStack()
    else
        let l:stack = g:GetLocalSFStack()
    endif
    if l:stack.empty()
        call xolox#misc#msg#info('searchfold stack is empty')
        return -1
    endif
    let l:last = l:stack.pop()
    call histadd('search', l:last)
    call setreg('/', l:last)
    if(a:apply)
        exec "norm \<Plug>SearchFoldNormal"
    endif
endf
map <Leader><Leader>z :call g:PopSearchFoldPattern(1, 0)<CR>zv<F10>__hl
map <Leader><Leader>Z :call g:PopSearchFoldPattern(1, 1)<CR>zv<F10>__hl
map <Leader>z :call g:PushSearchFoldPattern()<CR><Plug>SearchFoldNormalzv<F10>__hl

" Default Searchfold
let g:searchfold_do_maps = 0
" nmap <Leader>z   <Plug>SearchFoldNormal
nmap <Leader><Leader><Leader>z  <Plug>SearchFoldInverse
nmap <Leader><Leader><Leader>Z  <Plug>SearchFoldRestore
