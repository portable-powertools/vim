fun! RegWriteAndLoadIntoBuffer(file, modeAtWriting) abort
    exec "edit! ".a:file
    set nofixeol noeol
    if a:modeAtWriting ==# 'V'
        normal Go
    endif
endf
fun! RegModeFromList(list) abort
    if empty(a:list) || !empty(a:list[-1])
        return 'v'
    endif
    return 'V'
endf
fun! Get_reg2list(regname) abort
    let processed = getreg('+', 1, 1) + (getregtype('+') ==# "V" ? [''] : [] )
    return processed 
endf
fun! Set_list2reg(regname, list) abort
    let mode = RegModeFromList(a:list)
    if mode ==# 'V'
        " we have of course to strip that indicating newline again
        let internalRepr = a:list[0:-2]
    else
        let internalRepr = a:list
    endif
    " echom 'the mode is: '.mode
    call setreg(a:regname, internalRepr, mode)
    return getreg(a:regname)
endf
fun! Rf(file) abort
    return readfile(a:file, 'b')
endf
fun! Wf(content, file) abort
    call writefile(a:content, a:file, 'b')
    return RegModeFromList(a:content)
endf

echom '-----------'

fun! Routine() abort
    let file = '/tmp/1eol2'

    call setreg('+', "a")
    echom string(Get_reg2list('+'))
    echom string(Set_list2reg('+', Get_reg2list('+')))
    let content = Get_reg2list('+')
    echom string(content)
    let modeAtWriting = Wf(content, file)
    echom string(Rf(file))

    let listRepr = Get_reg2list('+')
    call Wf(Get_reg2list('+'), file)
    split
    call RegWriteAndLoadIntoBuffer(file, modeAtWriting)
    w
    wincmd p
    let readfromfile = Rf(file)
    echom '~ ~ ~'
    echom string(readfromfile)
    echom string(Set_list2reg('+', readfromfile))
    echom string(Get_reg2list('+'))
endf

call Routine() | normal [21~W
" call Routine() | call Routine() | normal [21~W
