" TODO idea: motion from ninja-feet z], z[


nmap <C-j><C-l> :set opfunc=PasteLineToCmdOpfun<CR>g@
xmap <silent> <Leader>m :<C-U>call MoveOp("visual")<CR>
"TODO: sunday PasteLineToCmdOpfun
function! PasteLineToCmdOpfun(type) abort
    let opdata = OperatorData(ParseOpfunData(a:type))
    echom string([line('.'), rangeL, rangeR])
    " call g:FlashVisual(subject[5][0], subject[5][1], 2, 100)
    " let g:_moveop_payload = g:DoOnRangeCmd(subject, "%st%%s")
    " call feedkeys(":\<C-\>eg:CmdlineGoToPlaceholder(g:_moveop_payload, '%s')\<CR>")
endfunction

nmap <silent> <Leader>m :set opfunc=MoveOp<CR>g@
xmap <silent> <Leader>m :<C-U>call MoveOp("visual")<CR>
nmap <silent> <Leader><Leader>m :set opfunc=TakeOp<CR>g@
xmap <silent> <Leader><Leader>m :<C-U>call TakeOp("visual")<CR>

function! TakeOp(type) abort
    let opdata = OperatorData(ParseOpfunData(a:type))
    call g:FlashVisual(opdata.posrange[0], opdata.posrange[1], 2, 100)
    let g:_moveop_payload = g:DoOnRangeCmd(opdata, "%st%%s")
    call feedkeys(":\<C-\>eg:CmdlineGoToPlaceholder(g:_moveop_payload, '%s')\<CR>")
endfunction
function! MoveOp(type) abort
    let opdata = OperatorData(ParseOpfunData(a:type))
    call g:FlashVisual(opdata.posrange[0], opdata.posrange[1], 2, 100)
    let g:_moveop_payload = g:DoOnRangeCmd(opdata, "%sm%%s", "`", "+1")
    call feedkeys(":\<C-\>eg:CmdlineGoToPlaceholder(g:_moveop_payload, '%s')\<CR>")
endfunction


""""""""""""""""""""""
"  easymotion stuff  "
""""""""""""""""""""""
" TODO: not abortable... not used anywhere as of nov2018
fun! g:SelectEMRange() abort
    let [retv, line1] = g:GetEMLineNr()
    if retv == 0
        let [retv, line2] = g:GetEMLineNr()
        if retv == 0
            call g:SetVisualPos(g:MakeVisPos(line1, line2), 1)
        else
            echom 'aborted'
            call feedkeys("\<ESC>")
        endif
    else
        echom 'aborted!'
        call feedkeys("\<ESC>")
    endif
endf


"""""""""""""""""""""""""""""""""""
"  command line formatting utils  "
"""""""""""""""""""""""""""""""""""


fun! g:CmdlineGoToPlaceholder(cmdline, placeholder) abort
    let idx = stridx(a:cmdline, a:placeholder)
    call setcmdpos(idx+1)
    return substitute(a:cmdline, '\V'.a:placeholder, '', '')
endf

""""""""""""""""""""""""""""""
"  range command groundwork  "
""""""""""""""""""""""""""""""

" command is a printf format string to be evaluated by thisfunction, with the range being the argument
" options: markname ('a', '`'), and markpos('+1' or '+0' or '-0' or '-3'), need both be specified, to drop a mark relative to the oprange bounds
fun! g:DoOnRangeCmd(opdata, command, ...) abort
    let [a:markstart, a:markend] = a:opdata.markerrange
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
        "TODO: selectafter could be quite useful!
    endif

    return markSthCmd . coreCmd . selectafterCmd
endf

