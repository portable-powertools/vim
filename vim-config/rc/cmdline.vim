" Mark -1 in command line
cnoremap <F10>' '-1<Left><Left>
cnoremap <F10>` `-1<Left><Left>
cnoremap <C-d>' ''<Left>
cnoremap <C-d>" ""<Left>
cnoremap <C-d>) ()<Left>
cnoremap <C-d>] []<Left>

" for stuff that takes a range
cmap <F10>g <Home>%
cmap <F10><F10><Home> <Home>1,.-1
cmap <F10><F10><End> <Home>.+1,$

cmap <F10>d <C-r>=getcwd()<CR><Space>
cmap <F10>D <C-r>=getcwd(-1)<CR><Space>

" for m in moveremaps
"     cmap <C-l> <C-\>eg:PushCommandModeC()<CR><CR>:call g:cmdModeStack.push(g:CommandEMLineInsert(g:cmdModeStack.pop()))<CR>:call g:PopCommandModeN()<CR>
" endfor

" TODO: move all mappings that can fail into functions! or at leasy 'try' ;)

fun! DelPopTop() abort
    try
        call g:cmdModeStack.pop()
    endtry
endf
fun! DelPopbackTop() abort
    try
        call g:PopBackCommand() 
        call g:cmdModeStack.pop()
    endtry
endf

nmap <C-j><C-d> <C-j>d
nmap <C-j>d :call DelPopTop() <bar> echo g:CmdStackSummary()<CR>
nmap <C-j>D :call DelPopbackTop() <bar> echo g:CmdStackSummary()<CR>
nmap <C-j>x :let g:cmdModeStack = lh#stack#new() <bar> echo g:CmdStackSummary()<CR>
nmap <C-j>X :let g:cmdModeStack = lh#stack#new() <bar>let g:cmdModeStackPopped = lh#stack#new() <bar> echo g:CmdStackSummary()<CR>
nmap <C-j>i <C-j><C-i>
nmap <C-j><C-i> :call g:PopBackCommand() <bar> echo g:CmdStackSummary()<CR>
nmap <C-j> <C-j>o
nmap <C-j><C-o> :call g:PopCommand() <bar> echo g:CmdStackSummary()<CR>
" info
nmap <C-j>[1;5A <C-j><Up>
nmap <C-j>[1;5B <C-j><Down>
nmap <C-j><Up> :echo "PUSHBACK: \n\n" <bar> call g:ShowCmdStack(g:cmdModeStackPopped, 0)<CR>
nmap <C-j><Down> :echo "COMMAND: \n\n" <bar> :call g:ShowCmdStack(g:cmdModeStack, 1)<CR>
nmap <C-j> <C-j>?
nmap <C-j>? :echo g:CmdStackSummary()<CR>
nmap <C-j><Leader>? :echo g:CmdStackPretty()<CR>
" normal mode stuff
nmap <C-j>= :call g:cmdModeStack.push(g:cmdModeStack.top()) <bar> echo g:CmdStackSummary()<CR>
nmap <C-j>: :call g:PeekCommandModeN()<CR>
nmap <C-j>; :call g:PeekCommandModeN()<CR>
nmap <C-j><C-j> :call g:PopCommandModeN()<CR>
nmap <C-j><C-p> :call g:cmdModeStack.push(g:CommandStringInsert(g:cmdModeStack.pop(), getreg(g:defaultreg)))<CR>:call g:PopCommandModeN()<CR>
nmap <C-j>,. :call g:cmdModeStack.push(g:CommandStringInsert(g:cmdModeStack.pop(), string(line('.'))))<CR>:call g:PopCommandModeN(1)<CR>
nmap <C-j>. :call g:cmdModeStack.push(g:CommandStringInsert(g:cmdModeStack.pop(), string(line('.'))))<CR>:call g:PopCommandModeN(1)<CR>

"command mode sstuff
cmap <C-j><C-j> <C-\>eg:PushCommandModeC()<CR><End><C-u><CR>
cmap <C-j>= <C-\>eg:PushCommandModeC()<CR>
cmap <C-j><C-d> <C-\>eg:RestoreCommandModeC(cmdModeStack.empty() ? g:CommandCurrent() : [g:cmdModeStack.pop(), (g:cmdModeStackPopped.empty() ? g:CommandCurrent() : [ g:PopBackCommand(), g:cmdModeStack.top() ][1])][1])<CR>
cmap <C-j><C-i> <C-\>eg:RestoreCommandModeC(g:cmdModeStackPopped.empty() ? g:CommandCurrent() : [ g:PopBackCommand(), g:cmdModeStack.top() ][1])<CR>
cmap <C-j><C-o> <C-\>eg:RestoreCommandModeC(g:cmdModeStack.empty() ? g:CommandCurrent() : [ g:PopCommand(), g:cmdModeStack.empty()?g:CommandEmpty():g:cmdModeStack.top() ][1])<CR>
cmap <C-l> <C-\>eg:PushCommandModeC()<CR><End><C-u><CR>:call g:cmdModeStack.push(g:CommandEMLineInsert(g:cmdModeStack.pop()))<CR>:call g:PopCommandModeN()<CR>

cnoremap <expr> <f10>mm (stridx(':', getcmdtype()) == -1 ? '<F10>mm' : '<C-\>e(g:ChangeMarkCLine(getcmdline(), 1, ''+1''))<CR>')

augroup cmdwin
    au!
    " autocmd CmdwinEnter * nmap <buffer> <Leader>x Go<C-m>
    autocmd CmdwinEnter * nmap <buffer> <Leader>x :q<C-m>
    autocmd CmdwinEnter * vmap <buffer> <Leader>d/ :<C-u>call g:RmSearch(g:Get_visual_selection(0))<CR>:q<CR>
    " autocmd CmdwinEnter * exec 'nmap <buffer> <Leader>m :call g:ReopenCmdWin("'.expand("<afile>").'")<CR>'
augroup end


" removing a search directly from the search history / q-edit window (cf. Plugin taggesdearch)
fun! g:RmSearch(literals)
    call histdel('search', '\V'.escape(a:literals, '\'))
endf

fun! g:CommandStringInsert(element, content) abort
    let [cmdline, cmdpos, cmdtype] = a:element

    let mask = g:CmdPosFmt(a:element)
    return [printf(mask, a:content), cmdpos+strchars(a:content), cmdtype]
endf
fun! g:CommandEMLineInsert(element) abort
    let [cmdline, cmdpos, cmdtype] = a:element

    let [retv, line] = g:GetEMLineNr()
    if retv == 0
        let mask = g:CmdPosFmt(a:element)
        return [printf(mask, string(line)), cmdpos+strchars(line), cmdtype]
    else
        return a:element
    endif
endf

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Methods to facilitate matching and changing a mark live  "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! g:FindRange(str, nr)
    return matchstr(a:str, '\v(''[<>a-z.]([\+\-]\d*)?)(,(''[<>a-z.]([\+\-]\d*)?))?', 0, a:nr)
endf
fun! g:FindEndOfRange(str, nr)
    let l:range=g:FindRange(a:str, a:nr)
    if ! empty(l:range)
        let l:lastEl = g:GetMark(l:range, 2)
        if empty(l:lastEl)
            return l:range
        else
            return l:lastEl
        endif
    else
        return ''
    endif
endf
fun! g:ChangeMarkCLine(line, ...)
    let l:numero = get(a:, 1, '1')
    let l:append = get(a:, 2, '-1')
    let l:mark=g:FindEndOfRange(a:line, numero)
    if ! empty(l:mark)
        return l:mark.l:append.'k` | '.a:line
    else
        return a:line
    endif
endf
fun! g:GetMark(str, nr)
    return matchstr(a:str, '\v(''[<>a-z.]([\+\-]\d*)?)', 0, a:nr)
endf


""""""""""""""""
"  formatting  "
""""""""""""""""

" formats the commandline stack element as string with default placeholder '%s' at curpos
" optional: shift, placeholder
fun! g:CmdPosFmt(cmdlineSpec, ...) abort
    let shift = get(a:, 1, 0)
    let placeholder = get(a:, 2, '%s')
    let [cmdline, cmdpos, cmdtype] = a:cmdlineSpec
    let idx = cmdpos - 1
    if idx + shift < 0
        call xolox#misc#msg#warn('in CmdPosPlaceholer, shift was going out of whack to the left; was normalized.')
        let shift = - idx
    endif
    if idx + shift > strchars(cmdline)
        call xolox#misc#msg#warn('in CmdPosPlaceholer, shift was going out of whack to the right; was normalized.')
        let shift = strchars(cmdline) - idx
    endif
    let head = strcharpart(cmdline, 0, idx+shift)
    let tail = strcharpart(cmdline, idx+shift)
    return head . placeholder . tail
endf

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  utils to do normal mode stuff inbetween a command line mode session  "
"  see snippets cmdfmap, cmdfmapf
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if !exists('g:cmdModeStack')
    let g:cmdModeStack = lh#stack#new()
endif
" Pushes the current command mode, and restores it directly
fun! g:CommandEmpty() abort
    let cmdline = ''
    let cmdpos = 1
    let cmdtype = ':'
    return [cmdline, cmdpos, cmdtype]
endf
fun! g:CommandCurrent() abort
    let cmdline = getcmdline()
    let cmdpos = getcmdpos()
    let cmdtype = getcmdtype()
    return [cmdline, cmdpos, cmdtype]
endf
fun! g:PushCommandModeC() abort
    let stackelement = g:CommandCurrent()
    call g:cmdModeStack.push(stackelement)
    return g:RestoreCommandModeC(stackelement)
endf
fun! g:RestoreCommandModeC(element) abort
    let [cmdline, cmdpos, cmdtype] = a:element
    "TODO: cmdtype is missing but that is sonmething for PopCommandModeN?
    call setcmdpos(cmdpos)
    return cmdline
endf
fun! g:PeekCommandModeN() abort
    if ! g:cmdModeStack.empty()
        call feedkeys(":\<C-\>eg:RestoreCommandModeC(g:cmdModeStack.top())\<CR>")
    else
        call xolox#misc#msg#warn('The command mode stack is empty')
    endif
endf

if ! exists('g:cmdModeStackPopped')
    let g:cmdModeStackPopped = lh#stack#new()
endif
fun! g:PopBackCommand() abort
    if ! g:cmdModeStackPopped.empty()
        call g:cmdModeStack.push(g:cmdModeStackPopped.pop())
    else
        echoerr 'popback stack empty'
    endif
endf
fun! g:PopCommand() abort
    if ! g:cmdModeStack.empty()
        call g:cmdModeStackPopped.push(g:cmdModeStack.pop())
    else
        echoerr 'cmdstack empty'
    endif
endf
fun! g:PopCommandModeN(...) abort
    let directCR = get(a:, 1, 0)
    if ! g:cmdModeStack.empty()
        call g:PopCommand()
        call feedkeys(":\<C-\>eg:RestoreCommandModeC(g:cmdModeStackPopped.top())\<CR>")
        if !empty(directCR)
            call feedkeys("\<CR>")
        endif
    else
        call xolox#misc#msg#warn('The command mode stack is empty')
    endif
endf


let g:cmd_cursorsign = '⎀'
fun! g:ShowCmdStack(stack, ...) abort
    let a:dir = get(a:, 1, 0)
    if a:stack.empty()
        echo 'this stack is empty'
    endif
    if a:dir == 0
        let printlist = a:stack.values
    else
        let printlist = reverse(copy(a:stack.values))
    endif
    for el in printlist 
        let curposFormatted = g:CmdPosFmt(el, 0, g:cmd_cursorsign)
        " let curposFormatted = g:CmdPosFmt(el, 0, g:cmd_cursorsign)
        echom printf('> %s', curposFormatted)
    endfor
    echo ''
endf
fun! g:CmdStackSummary() abort
    return printf("(↑↑):%s (↓↓):%s\t\t\t(↑): %s  \t (↓): %s ", len(g:cmdModeStack.values), len(g:cmdModeStackPopped.values), g:cmdModeStack.empty() ? '<empty>' : g:CmdPosFmt(g:cmdModeStack.top(), 0, g:cmd_cursorsign), g:cmdModeStackPopped.empty() ? '<empty>' : g:CmdPosFmt(g:cmdModeStackPopped.top(), 0, g:cmd_cursorsign))
endf
fun! CmdStackPretty() abort
    let result = ''
    redir => result
        silent call ShowCmdStack(g:cmdModeStackPopped, 0)
    redir END
    let result = trim(result)
    redir =>> result
        silent echo '===== ' .CmdStackSummary() . ' ====='
    redir END
    redir =>> result
        silent call ShowCmdStack(g:cmdModeStack, 1)
    redir END
    return result
    return ''
endf
