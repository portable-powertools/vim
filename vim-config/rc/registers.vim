nmap "" :exec 'Regedit '.v:register<CR>
nmap <F9>w :Regwrite 
cmap <f9>d /tmp/buffest/
" more: 


" ideas: 
" * convenience mapping for $0
" * resize buffer to lines + 2
" set default reg
" go back and paste/upaste/undo with that reg
" dirvish directory: open preview buffer (later: conceal)
fun! RegsMappings() abort
    " nmap <buffer> <Leader>u :set filetype=buffestreg.snippets<CR>
    nmap <buffer> <silent> <F9><F9> :let g:lastUsnipReg=exists('b:buffest_regname') ? b:buffest_regname : g:lastUsnipReg<CR>
    nmap <buffer> "<Space> :execute 'wincmd p' <bar> call feedkeys('"'.RegsWinRegister(winnr('#')))<CR>
    " nmap <buffer> <Leader>u :set filetype=buffestreg.snippets

endf

fun! RegsIsRegWin(...) abort
    let wnr = get(a:, 1, winnr())
    return !empty(RegsWinRegister(wnr))
endf
fun! RegsWinRegister(...) abort
    let wnr = get(a:, 1, winnr())
    return getbufvar(GetWinInfo(wnr).bufnr, 'buffest_regname')
endf

let g:regs_max_height = 10
fun! ResizeRegWin(...) abort
    let wnr = get(a:, 1, winnr())
    call lh#assert#true(wnr == winnr()) " other cases later...
    if RegsIsRegWin(wnr)
        let lines = line('$')
        call WinVertResize(winnr(), lines, g:regs_max_height)
    else
        call s:Verbose('is no reg window: %1', wnr)
    endif
endf

augroup regedit
    au!
    autocmd FileType buffestreg call RegsOnBufedit()
augroup end

fun! RegsOnBufedit() abort
    call RegsMappings()
    set filetype=buffestreg.snippets
    lcd %:p:h
endf



" Helpers


fun! RegNames() abort
    let regnames = []
    for i in range(26)
        let ch = nr2char(char2nr('a') + i)
        call add(regnames, ch)
    endfor
    let regnames = regnames + ['+', '*', '"']
    return regnames
endf
fun! RegsAssignGeneric(fmtstring) abort
    for n in RegNames()
        call setreg(n, Prt(a:fmtstring, n))
    endfor
endf
