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

" let @e='hiiiii$1hooooo$2!'
" let @+='hiiiii++$1++hooooo$2!'

fun! FindRegWin(...) abort
    let validregs = RegNames()
    if a:0 > 0
        let validregs = [a:1]
    endif
    let validregnames = map(validregs, {i, r -> buffest#tmpname('@'.r)})
    let regidx = 0
    while regidx < len(validregnames)
        let findres = lh#buffer#find(validregnames[regidx])
        if findres != -1
            return 1
        endif
        let regidx = regidx + 1
    endwhile
    echo 'no reg window found'
    return -1
endf

nmap <F9>G :call FindRegWin()<CR>
nmap <F9>g :call FindRegWin(v:register)<CR>
nmap <F9>p :call AnonRegSnipN(v:register, 'a')<CR>
nmap <F9>P :call AnonRegSnipN(v:register, 'i')<CR>
nmap <F9><F9>p :call AnonRegSnipN(g:lastUsnipReg, 'a')<CR>
nmap <F9><F9>P :call AnonRegSnipN(g:lastUsnipReg, 'i')<CR>
nmap <F9><F9>e :split <bar> exec "Regedit ".g:lastUsnipReg<CR>
imap <expr> <F9>p AnonRegSnipI()
imap <expr> <F9><F9> AnonRegSnipI(g:lastUsnipReg)

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
    if empty(reg)
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




fun! g:UsnipOfLastVisual()
    let delCapture = get(a:, 1, {})

    let l:selection = Get_visual_selection(1)
    call g:DelLastSelectionNoDedent()
    call g:UsnipAnonDedenting(l:selection, 'a')
endf

fun! g:UsnipAnonDedenting(snippet, ...)
    return call('g:UsnipAnon', [xolox#misc#str#dedent(a:snippet)] + a:000)
endf

" optional: options (i), description(""), trigger(see below)
fun! g:UsnipAnon(snippet, ...)
    let a:nmodeInitSeq = get(a:, 1, 'a')
    let a:options = get(a:, 2, 'i')
    let a:descr = get(a:, 3, '')
    let a:trigger = get(a:, 4, '__snippettrigger__')
    let g:snippetToExpand=a:snippet
    "TODOitclean: snippettoexpand is a global funnelling mess and won't scale
    call UltiSnips#CursorMoved()
    call feedkeys("\<Esc>".a:nmodeInitSeq.a:trigger."\<C-R>=UltiSnips#Anon(g:snippetToExpand, '".a:trigger."', '', '".a:options."')\<CR>")
    " normal a__snippettrigger__=UltiSnips#Anon(g:snippetToExpand, '__snippettrigger__')
endf
