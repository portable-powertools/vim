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

let g:r1=g:OpfunSelection('visual')
let g:pl1 = ''']+1k` | ''[,'']m%s | call g:SetVisualPos([0, 5, 1, 0], [0, 11, 2147483647, 0], 1)'
echo g:CmdlineGoToPlaceholder(g:pl1, '%s')

echo string(g:r1)
echo g:DoOnRangeCmd(g:r1, '%sm%%s', '`', '+1', 1)


