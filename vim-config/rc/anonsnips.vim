let s:k_script_name = expand('<sfile>:p')
let s:verbose = get(s:, 'verbose', 0)
function! ASnipVerbose(...)
  if a:0 > 0
    let s:verbose = a:1
  endif
  return s:verbose
endfunction
function! s:Log(...)
  call call('lh#log#this', a:000)
endfunction
function! s:Verbose(...)
  if s:verbose
    call call('s:Log', a:000)
  endif
endfunction
call ASnipVerbose(1)

nmap <F10>us vgb<Leader>us
nmap <F10>Us vgb<Leader>Us
imap <F10>us <Esc><F10>us
imap <F10>Us <Esc><F10>Us
" vmap <Leader>us "zxi_adhoc_<C-R>=UltiSnips#Anon(getreg('z'), '_adhoc_', '', 'i')<CR>
" vmap <Leader>Us "zxa_adhoc_<C-R>=UltiSnips#Anon(getreg('z'), '_adhoc_', '', 'i')<CR>



let @e='hiiiii$1hooooo$2!'
let @+='hiiiii$1hooooo$2!'

nmap <F10>p :call AnonRegSnipN(v:register, 'a')<CR>
nmap <F10>P :call AnonRegSnipN(v:register, 'i')<CR>
nmap <F10><F10>p :call AnonRegSnipN(g:lastUsnipReg, 'a')<CR>
nmap <F10><F10>P :call AnonRegSnipN(g:lastUsnipReg, 'i')<CR>
nmap <F10><F10>e :split <bar> exec "Regedit ".g:lastUsnipReg<CR>
imap <expr> <F10>p AnonRegSnipI()
imap <expr> <F10><F10>p AnonRegSnipI(g:lastUsnipReg)

nmap ;r :exec 'Regedit '.v:register<CR>

if !exists('g:lastUsnipReg')
    let g:lastUsnipReg = g:defaultreg
endif

fun! AnonRegSnipN(register, ...) abort
    let nmodeChar = get(a:, 1, 'a')
    let regname = a:register == '_' ? g:defaultreg : a:register
    let regcontent = substitute(getreg(regname), '\v\n*$', '', '')
    let g:lastUsnipReg = regname
    call UsnipAnon(regcontent, nmodeChar)
endf
fun! AnonRegSnipI(...) abort
    let reg = get(a:, 1, '')
    if !empty(reg)
    let char = nr2char(getchar())
        if match(char, '\V\c\[a-z"+*]') == 0
            let reg = char
        elseif char == ' '
            let reg = g:defaultreg
        endif
    endif
    if (getpos("'^")[2] == 1)
        let nmodeChar = 'i'
    else
        let nmodeChar = 'a'
    endif
    return "\<C-o>:call AnonRegSnipN('".reg."', '".nmodeChar."')\<CR>"
endf



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                            registers.vim                            "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

augroup regedit
    au!
    autocmd FileType buffestreg call RegsOnBufedit()
augroup end

fun! RegsOnBufedit() abort
    call RegsMappings()
    set filetype=buffestreg.snippets
endf

" more: 

" ideas: 
" * convenience mapping for $0
" * resize buffer to lines + 2
" set default reg
" go back and paste/upaste/undo with that reg
" dirvish directory: open preview buffer (later: conceal)
fun! RegsMappings() abort
    " nmap <buffer> <Leader>u :set filetype=buffestreg.snippets<CR>
    nmap <buffer> <silent> <F10><F10> :let g:lastUsnipReg=exists('b:buffest_regname') ? b:buffest_regname : g:lastUsnipReg<CR>
    nmap <buffer> <silent> <F10><F10> :let g:lastUsnipReg=exists('b:buffest_regname') ? b:buffest_regname : g:lastUsnipReg<CR>
    nmap <buffer> <Leader>" :execute 'wincmd p' <bar> call feedkeys('"'.RegsWinRegister(winnr('#')))<CR>
    nmap <buffer> <Leader>u :set filetype=buffestreg.snippets
    nmap <buffer> <silent> <Leader>rr :call ResizeRegWin()<CR>
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
