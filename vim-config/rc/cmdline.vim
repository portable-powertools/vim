" q-edit but a bit faster
nmap <Leader>q; q:

augroup cmdwin
    au!
    " autocmd CmdwinEnter * nmap <buffer> <Leader>x Go<C-m>
    autocmd CmdwinEnter * nmap <buffer> <Leader>x :q<C-m>
    autocmd CmdwinEnter * vmap <buffer> <Leader>d :<C-u>call g:RmSearch(g:Get_visual_selection())<CR>:q<CR>
    " autocmd CmdwinEnter * exec 'nmap <buffer> <Leader>m :call g:ReopenCmdWin("'.expand("<afile>").'")<CR>'
augroup end


cnoremap <expr> <f10>mm (stridx(':', getcmdtype()) == -1 ? '<F10>mm' : '<C-\>e(g:ChangeMarkCLine(getcmdline(), 1, ''+1''))<CR>')


" removing a search directly from the search history / q-edit window (cf. Plugin taggesdearch)
fun! g:RmSearch(literals)
    call histdel('search', '\V'.escape(a:literals, '\'))
endf

" Methods to facilitate matching and changing a mark live

fun! g:GetRange(str, nr)
    return matchstr(a:str, '\v(''[<>a-z.]([\+\-]\d*)?)(,(''[<>a-z.]([\+\-]\d*)?))?', 0, a:nr)
endf
fun! g:GetEndOfRange(str, nr)
    let l:range=g:GetRange(a:str, a:nr)
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
    let l:mark=g:GetEndOfRange(a:line, numero)
    if ! empty(l:mark)
        return l:mark.l:append.'k` | '.a:line
    else
        return a:line
    endif
endf
fun! g:GetMark(str, nr)
    return matchstr(a:str, '\v(''[<>a-z.]([\+\-]\d*)?)', 0, a:nr)
endf
