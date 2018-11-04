
nmap <silent> <Leader>m :set opfunc=MoveOp<CR>g@
vmap <silent> <Leader>m :<C-U>call MoveOp("visual")<CR>
nmap <silent> <Leader>M :set opfunc=TakeOp<CR>g@
vmap <silent> <Leader>M :<C-U>call TakeOp("visual")<CR>

" OpfunSelection returns [stringcontent, [line,col], [line,col], [mark1Str, mark2Str], type, [complPos1, complPos2]] // type=visual/line/char/block // markStr is '[,'],'< or '>
function! TakeOp(type) abort
    let subject = g:OpfunSelection(a:type)
    let [rangeL, rangeR; _] = subject[3]
    call g:FlashVisual(subject[5][0], subject[5][1], 2, 100)
    let g:_moveop_payload = g:DoOnRangeCmd(subject, "%st%%s", "`", "+1")
    call feedkeys(":\<C-\>eg:CmdlineGoToPlaceholder(g:_moveop_payload, '%s')\<CR>")
endfunction
function! MoveOp(type) abort
    let subject = g:OpfunSelection(a:type)
    let [rangeL, rangeR; _] = subject[3]
    call g:FlashVisual(subject[5][0], subject[5][1], 2, 100)
    let g:_moveop_payload = g:DoOnRangeCmd(subject, "%sm%%s", "`", "+1")
    call feedkeys(":\<C-\>eg:CmdlineGoToPlaceholder(g:_moveop_payload, '%s')\<CR>")
endfunction


fun! g:CmdlineGoToPlaceholder(cmdline, placeholder) abort
    let idx = stridx(a:cmdline, a:placeholder)
    call setcmdpos(idx+1)
    return substitute(a:cmdline, '\V'.a:placeholder, '', '')
endf

fun! g:DoOnRangeCmd(range, command, ...) abort
    let [a:markstart, a:markend] = a:range[3]
    let a:markname = get(a:, 1, '')
    let a:markpos = get(a:, 2, '<empty>')
    let a:selectafter = get(a:, 3, 0)
    "todo: support pos arrays?

    let coreCmd = printf(a:command, printf('%s,%s', a:markstart, a:markend))

    let markSthCmd = ''
    if !empty(a:markname)
        let relmark=a:markend
        if a:markpos[0] == '-'
            let relmark=a:markstart
        endif
        let markSthCmd = call('printf', ['%s%sk%s | '] + [relmark, a:markpos, a:markname])
    endif

    let selectafterCmd = ''
    if a:selectafter && 0
        " TODO: doesnt work _quite_ yet, the below is a valid command and selects the initial range but this is not very useful.
        " let selectafterCmd = printf(' | call g:SetVisualPos(%s, %s, 1)', string(a:range[5][0]), string(a:range[5][1]))
    endif

    return markSthCmd . coreCmd . selectafterCmd
endf

" returns [stringcontent, [line,col], [line,col], [mark1Str, mark2Str], type, [complPos1, complPos2]] // type=visual/line/whatever a:type contains
fun! g:OpfunSelection(type) abort
    "type can be line, char, block, visual" -- with visual, gv get us the right selection. user can then check for trailing newline herself...

    if a:type == 'visual'
        let evalpos = g:GetVisualPos()
        return [g:GVS(), evalpos[0][1:2], evalpos[1][1:2], ["'<","'>"], "visual", evalpos]
    else
        let vispos = g:GetVisualPos()
        let pos = getpos(".")
        if a:type == 'line'
            silent keepj exe "normal! '[V']"
        else
            silent keepj exe "normal! `[v`]"
        endif
        let evalpos = g:GetVisualPos()
        silent keepj norm 
        let l:content = g:GVS()
        keepj call call('g:SetVisualPos', vispos)
        keepj call setpos(".", pos)
        return [l:content, evalpos[0][1:2], evalpos[1][1:2], ["'[","']"], a:type, evalpos]
    endif
endf
