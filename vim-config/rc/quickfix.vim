
"""""""""""""""""""""""
"  debugging with QF  "
"""""""""""""""""""""""

if !exists('g:msgLastEnd')
    let msgLastEnd = -1
endif
command! -nargs=0 MessagesLast cope | Messages | exec "normal G" | let msgRecent = min([msgLastEnd + 1, line('$')]) | if msgLastEnd < line('$') | call FlashLines(msgRecent, line('$'), 2, 150) | endif | let msgLastEnd = line('$') | exec "normal :".(msgRecent)."\<CR>"
" exec "normal \<Leader>cp"
command! -nargs=? WTF call lh#exception#say_what(<args>)
nmap <F10>W :MessagesLast<CR>
nmap <F10>w :WTF<CR>
nnoremap <Leader><Leader>d :messages<CR>


""""""""""""""""""""""""""
"  the convenience maps  "
""""""""""""""""""""""""""

command! -nargs=* KeepName call g:WithVar('g:qf_bufname_or_text', 1, 'Keep '.<q-args>)
command! -nargs=* KeepCont call g:WithVar('g:qf_bufname_or_text', 2, 'Keep '.<q-args>)
command! -nargs=* KeepBoth call g:WithVar('g:qf_bufname_or_text', 0, 'Keep '.<q-args>)
command! -nargs=* RejectName call g:WithVar('g:qf_bufname_or_text', 1, 'Reject '.<q-args>)
command! -nargs=* RejectCont call g:WithVar('g:qf_bufname_or_text', 2, 'Reject '.<q-args>)
command! -nargs=* RejectBoth call g:WithVar('g:qf_bufname_or_text', 0, 'Reject '.<q-args>)
command! -nargs=* CResize silent! call g:QFResizeGlobal()

command! -nargs=0 CCD let g:qflistbase = getcwd() . '/.qf' | echom printf('Quickfix register dir is now %s', g:qflistbase)

nmap <Leader>crr :CResize<CR>

nmap <Leader>c: <Plug>(qf_qf_toggle)
nmap <Leader>c; <Plug>(qf_qf_toggle_stay)
nmap <Leader>a: <Plug>(qf_loc_toggle)
nmap <Leader>a; <Plug>(qf_loc_toggle_stay)

nmap <Leader>cp <Plug>(qf_qf_switch)
nmap <Leader>ap <Plug>(qf_loc_switch)

nnoremap <Leader>aj :ALENext<CR>
nnoremap <Leader>ak :ALEPrevious<CR>
nmap <Leader>cj <Plug>(qf_qf_next)
nmap <Leader>ck <Plug>(qf_qf_previous)
nmap <Leader>aaj <Plug>(qf_loc_next)
nmap <Leader>aak <Plug>(qf_loc_previous)

fun! RegisterQfMaps() abort
    nmap <silent><buffer> <Leader>m :.cc<CR><F10>__flash500<C-w>p
    nmap <silent><buffer> J j:.cc<CR><F10>__flash300<C-w>p
    nmap <silent><buffer> K k:.cc<CR><F10>__flash300<C-w>p
    nmap <buffer> <Leader><Leader>; <Plug>(qf_qf_switch)<F10>__flash300<Plug>(qf_qf_switch)

    nmap <buffer> <C-w>p <Plug>(qf_qf_switch)
    nmap <buffer> <Leader>c; <C-w>p<Leader>c;
    nmap <buffer> <Leader>x <C-w>p<Leader>c;
    nmap <buffer> <silent> u :silent! colder<CR>
    nmap <buffer> <silent> <C-r> :silent! cnewer<CR>
    
    nnoremap <buffer> <Space>y :call g:YankQF(g:QFFileAndMod(v:register)) <bar> CResize<CR>
    nnoremap <buffer> <Space>p :call g:PutQF(g:QFFileAndMod(v:register), 'forceAdd') <bar> CResize<CR>
    nnoremap <silent> <buffer> dae :cexpr []<CR>
endf
fun! RegisterLocMaps() abort
    nmap <silent><buffer> <Leader>m :.ll<CR><F10>__flash500<C-w>p
    nmap <silent><buffer> J j:.ll<CR><F10>__flash300<C-w>p
    nmap <silent><buffer> K k:.ll<CR><F10>__flash300<C-w>p
    nmap <buffer> <Leader><Leader>; <Plug>(qf_loc_switch)<F10>__flash300<Plug>(qf_loc_switch)

    nmap <buffer> <C-w>p <Plug>(qf_loc_switch)
    nmap <buffer> <Leader>c; <C-w>p<Leader>a;
    nmap <buffer> <Leader>x <C-w>p<Leader>a;
    nmap <buffer> <silent> u :silent! lolder<CR>
    nmap <buffer> <silent> <C-r> :silent! lnewer<CR>

    nnoremap <silent> <buffer> dae :lexpr []<CR>
endf
fun! RegisterGeneralMaps() abort
    nmap <buffer> <C-w>H :call g:QfLocMoveAndSetDefaultPos('H')<CR>
    nmap <buffer> <C-w>J :call g:QfLocMoveAndSetDefaultPos('J')<CR>
    nmap <buffer> <C-w>K :call g:QfLocMoveAndSetDefaultPos('K')<CR>
    nmap <buffer> <C-w>L :call g:QfLocMoveAndSetDefaultPos('L')<CR>
endf

"""""""""""""""""""""""""""""""
"  Plugin settings, volatile  "
"""""""""""""""""""""""""""""""


" Plugin: qf plugin settings
let g:qf_max_height = 20 " should be overruled by vim-qf_resize if qf.vim is not set to autoresize
let g:qf_window_bottom = 1 " should be overruled by vim-qf_resize if qf.vim is not set to autoresize
let g:qf_loclist_window_bottom = 1 " should be overruled by vim-qf_resize if qf.vim is not set to autoresize

" TODO: these settings interfere with my toggle and register commands wrt. focus
let g:qf_auto_open_quickfix = 0
let g:qf_auto_open_loclist = 0
let g:qf_auto_resize = 0
let g:qf_auto_quit = 0
let g:qf_nowrap = 1

"" Plugin: qfenter


" Plugin: vim-qf_resize (blueyed) (uncommented for all defaults...)
" let g:qf_resize_min_height = 3 " can be a buffer setting, "experimental internal defaults"
" let g:qf_resize_max_height = 15
" let g:qf_resize_max_ratio = 0.15
" let g:qf_resize_on_win_close = 1 " Resize/handle all qf windows when a window gets closed. Default: 1.

"" Plugin: QFEnter
let g:qfenter_enable_autoquickfix = 0
let g:qfenter_keymap = {}
let g:qfenter_keymap.open = ['<C-m>']
let g:qfenter_keymap.vopen = ['<Space>a']
let g:qfenter_keymap.hopen = ['<Space>o']
let g:qfenter_keymap.topen = ['<Space>t']
"" all supported commands: open, vopen, hopen, topen, cnext, vcnext, hcnext, tcnext, cprev, vcprev, hcprev, tcprev, 


"""""""""""""""""""""""
"  moving qf windows  "
"""""""""""""""""""""""

" moving the windows and have them stay there
if !exists('g:qf_defaultPos')
    let g:qf_defaultPos = 'J'
endif
if !exists('g:loc_defaultPos')
    let g:loc_defaultPos = 'H'
endif
fun! g:QfLocMoveAndSetDefaultPos(windcmdchar) abort
    if match(a:windcmdchar, '\C[HJKL]') == -1
        throw "QfMoveAndSetDefaultPos: no valid direction"
    endif
    if qf#IsQfWindow(winnr())
        let g:qf_defaultPos = a:windcmdchar
    else
        let g:loc_defaultPos = a:windcmdchar
    endif

    exec "normal! \<C-w>".a:windcmdchar
    CResize
endf

""""""""""""""""""""""""""""
"  autocommand definition  "
""""""""""""""""""""""""""""

fun! QfRegisterMappings() abort
    if qf#IsQfWindow(winnr())
        call RegisterQfMaps()
    endif

    if qf#IsLocWindow(winnr())
        call RegisterLocMaps()
    endif
    call RegisterGeneralMaps()
endf
fun! QfSetDefaultPosition() abort
    if qf#IsQfWindow(winnr())
        call RegisterQfMaps()
        exec "normal! \<C-w>".g:qf_defaultPos
        CResize
    endif
    if qf#IsLocWindow(winnr())
        call RegisterLocMaps()
        exec "normal! \<C-w>".g:loc_defaultPos
        CResize
    endif
    call RegisterGeneralMaps()
endf
fun! OnQfFiletype() abort
    call QfSetDefaultPosition()
    call QfRegisterMappings()
endf
augroup QfPosSimlei
    au!
    exec 'autocmd FileType qf call OnQfFiletype()'
augroup end

fun! g:QFResizeGlobal() abort
    if qf#IsQfWindowOpen() 
        for winnum in range(1, winnr('$'))
            let height = 1
            if qf#IsQfWindow(winnum)
                let height = getwininfo(win_getid(winnum))[0]['height']
            endif
        endfor
        let switchBack = 0
        if qf#IsQfWindow(winnr())
            let switchBack = 1
            exec "normal \<Plug>(qf_qf_switch)"
        endif
        QfResizeWindows " blueyed impl.
        if switchBack == 1
            exec "normal \<Plug>(qf_qf_switch)"
        endif

        " Legacy: with vim-qf stuff
        " let max_height = get(g:, 'qf_max_height', 10) < 1 ? 10 : get(g:, 'qf_max_height', 10) 
        " if height <= max_height || 1 " TODO: always resize... get it to work that qf doesnt maximize nor reopens vertically
        "     if qf#IsQfWindow(winnr())
        "         let switchBack = 0
        "         " call feedkeys("\<Plug>(qf_qf_switch)", 'x') 
        "         exec "normal \<Plug>(qf_qf_switch)"
        "     else
        "         let switchBack = 1
        "     endif
        "     execute get(g:, "qf_auto_resize", 1) ? 'cclose|' . min([ max_height, len(getqflist()) ]) . 'cwindow' : 'cwindow'
        "     if switchBack == 1
        "         exec "normal \<Plug>(qf_qf_switch)"
        "     endif
        " endif
    endif
endf

let g:currentQFListCanon = 'default'

"""""""""""""""""""""""""""""""""
"  QFRegisters and named lists  "
"""""""""""""""""""""""""""""""""

if ! exists('g:qflistbase')
    let g:qflistbase = getcwd(-1) . '/qf'
endif

" flags: 'forceAdd', 'P', 'changeCanon'
fun! g:PutQF(spec, ...) abort
    let [f, canon, isUp] = a:spec
    let modeOfPut = 'replace' " append, prepend
    let success = 0

    if index(a:000, 'P') != -1 && 'TODO: to be implemented'
        let modeOfPut = 'prepend'
    else
        if index(a:000, 'forceAdd') != -1 || isUp
            let modeOfPut = 'append'
        else
            let modeOfPut = 'replace'
        endif
    endif

    if filereadable(f)
        if modeOfPut == 'replace'
            exec 'Qfl '.f
            let success = 1
        elseif modeOfPut == 'append'
            exec 'Qfla '.f
            let success = 1
        elseif modeOfPut == 'prepend'
            call xolox#misc#msg#warn('Prepending a list to another has not yet been implemented!')
        endif
    else
        let namedlists = qf#namedlist#GetLists()
        if index(namedlists, canon) != -1
            call xolox#misc#msg#warn('Using named list ' . canon . ' - probably not saved!')
            if modeOfPut == 'replace'
                exec 'LoadList '.canon
                let success = 1
            elseif modeOfPut == 'append'
                exec 'LoadListAdd '.canon
                let success = 1
            elseif modeOfPut == 'prepend'
                call xolox#misc#msg#warn('Prepending a list to another has not yet been implemented!')
            endif
        else
            call xolox#misc#msg#warn(printf('No file ''%s'' and no named list ''%s''exist', f, canon))
        endif
    endif
    if success
        call xolox#misc#msg#info('put list with mode ' . modeOfPut . ' and flags ' . string(a:000) . ' into listreg ' . canon)
        if index(a:000, 'changeCanon')
            let g:currentQFListCanon = canon
            " call xolox#misc#msg#info('the current quickfix register is ' . canon)
        endif
    endif
endf
" flags: changeCanon
fun! g:YankQF(spec, ...) abort
    let [f, canon, isUp] = a:spec
    let success = 0
    if ! filewritable(f)
        call mkdir(fnamemodify(f, ':p:h'), 'p')
    endif
    if isUp
        call xolox#misc#msg#warn('Can''t currently append to a list by yanking; use SaveListAdd and "put" it afterwards')
    else
        exec 'Qfw ' . f
        exec 'SaveList ' . canon
        let success = 1
    endif
    
    if success
        call xolox#misc#msg#info('yanked list with flags ' . string(a:000) . ' to listreg ' . canon)
        if index(a:000, 'changeCanon')
            let g:currentQFListCanon = canon
            " call xolox#misc#msg#info('the current quickfix register is ' . canon)
        endif
    endif
endf

fun! g:QFFileAndMod(char) abort
    let uppat = '\v\C[A-Z]'
    let lowpat = '\v\C[a-z]'
    let alphapat = '\v[a-zA-Z]'
    let isDefault = (a:char ==# '"' || a:char ==# '+' || a:char == '*')
    let isalpha = match(a:char, alphapat) != -1
    let isUp = match(a:char, uppat) != -1
    let isLow = match(a:char, lowpat) != -1
    if isDefault
        return [g:qflistbase.'/'.'default'.'.qflist', 'default', isUp]
    endif
    if isalpha
        let canon = tolower(a:char)
        return [g:qflistbase.'/'.canon.'qflist', canon, isUp]
    else
        throw "no alpha character for g:QFFileAndMod: ". a:char
    endif
endf
fun! g:QFFile(char) abort
    return g:QFFileAndMod(a:char)
endf


"" Proxy cmd for implementation. Current: kickfix native writing
command! -nargs=1 Qfw w! <args>
command! -nargs=1 Qfl QLoad <args>
" append
command! -nargs=1 Qfla call g:QflaImpl(<f-args>)
" prepend
command! -nargs=1 QflA call g:QflAImpl(<f-args>)

" qf.vim powered append-paste style
fun! g:QflaImpl(file) abort
    SaveList buf1
    exec "QLoad ".a:file
    exec "normal \<Plug>(qf_qf_switch)"
    SaveList buf2
    LoadList buf1
    LoadListAdd buf2
endf
" qf.vim and kickfix powered prepend-paste style
fun! g:QflAImpl(file) abort
    SaveList buf1
    exec "QLoad ".a:file
    exec "normal \<Plug>(qf_qf_switch)"
    LoadListAdd buf1
endf

"""""""""""""""
"  Graveyard  "
"""""""""""""""


"" Plugin: QFEdit

" let g:editqf_no_mappings = 1
" nmap <Leader>cn <Plug>QFAddNote
" cmap <Leader>an <Plug>LocAddNote

" let g:editqf_saveqf_filename  = "quickfix.list"
" let g:editqf_saveloc_filename = "location.list"
" let g:editqf_jump_to_error = 0
" let g:editqf_store_absolute_filename = 1
