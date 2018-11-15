let s:k_script_name = expand('<sfile>:p')
let s:verbose = get(s:, 'verbose', 0)
function! QfVerbose(...)
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
" call QfVerbose(1)

"""""""""""""""""""""""
"  debugging with QF  "
"""""""""""""""""""""""

if !exists('g:msgLastEnd')
    let msgLastEnd = -1
endif
command! -nargs=0 MessagesLast cope | Messages | exec "normal G" | let msgRecent = min([msgLastEnd + 1, line('$')]) | if msgLastEnd < line('$') | call FlashLines(msgRecent, line('$'), 2, 150) | endif | let msgLastEnd = line('$') | exec "normal :".(msgRecent)."\<CR>"
" exec "normal \<Leader>cp"
command! -nargs=? WTF call lh#exception#say_what(<args>)
nmap <silent> <F10>W :MessagesLast<CR>
nmap <silent> <F10>w :WTF<CR>
nnoremap <Leader><Leader>d :messages<CR>


""""""""""""""""""""""""""
"  the convenience maps  "
""""""""""""""""""""""""""

command! -nargs=1 RejectExt RejectName .<args>$
command! -nargs=1 KeepExt KeepName .<args>$
command! -nargs=1 KeepName call g:WithVar('g:qf_bufname_or_text', 1, 'Keep '.<q-args>)
command! -nargs=1 KeepCont call g:WithVar('g:qf_bufname_or_text', 2, 'Keep '.<q-args>)
command! -nargs=1 KeepBoth call g:WithVar('g:qf_bufname_or_text', 0, 'Keep '.<q-args>)
command! -nargs=1 RejectName call g:WithVar('g:qf_bufname_or_text', 1, 'Reject '.<q-args>)
command! -nargs=1 RejectCont call g:WithVar('g:qf_bufname_or_text', 2, 'Reject '.<q-args>)
command! -nargs=1 RejectBoth call g:WithVar('g:qf_bufname_or_text', 0, 'Reject '.<q-args>)
command! -nargs=0 CResize silent! call g:QFResizeGlobal()

command! -nargs=0 CCD let g:qflistbase = getcwd() . '/.qf' | echo printf('Quickfix register dir is now %s', g:qflistbase)

nmap <Leader>crr :CResize<CR>

nmap <Leader>c: :call :<C-u>call RegisterQfPos()<CR><Plug>(qf_qf_toggle)
nmap <Leader>c; :call :<C-u>call RegisterQfPos()<CR><Plug>(qf_qf_toggle_stay)
nmap <Leader>a: :call :<C-u>call RegisterQfPos()<CR><Plug>(qf_loc_toggle)
nmap <Leader>a; :call :<C-u>call RegisterQfPos()<CR><Plug>(qf_loc_toggle_stay)


nmap <Leader>cp :<C-u>call RegisterQfPos()<CR>:<C-u>call qf#switch(1, 1, 0)<CR>
" use only the precise loc list
nmap <Leader>aP :<C-u>call RegisterQfPos()<CR>:<C-u>call qf#switch(2, 1, 1)<CR>
" use any loc list if the precise one is not found
nmap <Leader>ap :<C-u>call RegisterQfPos()<CR>:<C-u>call qf#switch(2, 1, 0)<CR>

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


    nmap <buffer> <Leader>c; <Leader>x
    nmap <buffer> <Leader>x :<C-u>call RegisterQfPos()<CR>:<C-u>call qf#switch(1, 0, 0) <bar> call qf#toggle#ToggleQfWindow(1)<CR>
    nmap <buffer> <C-w>p :<C-u>call qf#switch(1, 0, 0)<CR>

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

    " nmap <buffer> <C-w>p <Plug>(qf_loc_switch) " location lists in pairs..
    nmap <buffer> <Leader>a; <Leader>x
    nmap <buffer> <Leader>x :<C-u>call RegisterQfPos()<CR>:<C-u>call qf#switch(2, 0, 0) <bar> call qf#toggle#ToggleLocWindow(1)<CR>
    nmap <buffer> <C-w>p :<C-u>call qf#switch(2, 0, 0)<CR>

    nmap <buffer> <silent> u :silent! lolder<CR>
    nmap <buffer> <silent> <C-r> :silent! lnewer<CR>

    nnoremap <silent> <buffer> dae :lexpr []<CR>
endf
fun! RegisterGeneralMaps() abort
    nmap <buffer> <C-w>H :<C-u>call g:QfAdaptWinMovement('H', QfGetLastStateForCurrent())<CR>
    nmap <buffer> <C-w>J :<C-u>call g:QfAdaptWinMovement('J', QfGetLastStateForCurrent())<CR>
    nmap <buffer> <C-w>K :<C-u>call g:QfAdaptWinMovement('K', QfGetLastStateForCurrent())<CR>
    nmap <buffer> <C-w>L :<C-u>call g:QfAdaptWinMovement('L', QfGetLastStateForCurrent())<CR>
    nmap <buffer> <C-w><Space> :call RegisterQfPos()<CR>
endf


"""""""""""""""""""""""""""""""
"  Plugin settings, volatile  "
"""""""""""""""""""""""""""""""


" Plugin: qf plugin settings
let g:qf_max_height = 20 " should be overruled by vim-qf_resize if qf.vim is not set to autoresize
let g:qf_window_bottom = 0 " should be overruled by vim-qf_resize if qf.vim is not set to autoresize
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
let g:qf_resize_max_height = 20
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
if !exists('g:qf_lastPos')
    let g:qf_lastPos = {}
endif
if !exists('g:loc_lastPos')
    let g:loc_lastPos = {}
endif
fun! QfPositioningHook() abort
    let winnr = winnr()
    let type = qf#type(winnr)
    call lh#assert#true(type > 0)
    if qf#type(winnr) == 1
        if !empty(g:qf_lastPos)
            call g:qf_lastPos.qfinit_from_this(type)
        else
            call s:qfinit_fresh(type)
        endif
    endif
    if qf#type(winnr) == 2
        if !empty(g:loc_lastPos)
            call g:loc_lastPos.qfinit_from_this(type)
        else
            call s:qfinit_fresh(type)
        endif
    endif
endf
fun! QfGetLastStateForCurrent() abort
    let type = qf#type(winnr())
    call lh#assert#true(type > 0)
    if type == 1
        if empty('g:qf_lastPos')
            call RegisterQfPos()
        endif
        " call lh#assert#not_empty(g:qf_lastPos)
        " call s:Verbose('last pos: %1', g:qf_lastPos)
        
        return g:qf_lastPos
    elseif type == 2
        if !empty('g:loc_lastPos')
            call RegisterQfPos()
        endif
        return g:loc_lastPos
    endif
endf

fun! LastQfwinPos(winnr) abort
    let s = GetWinInfo(a:winnr)
    call lh#object#inject_methods(s, s:k_script_name, 'qfinit_from_this')
    return s
endf
fun! RegisterQfPos() abort
    let type = qf#type(winnr())
    
    "TODOitclean: now, I am assuming we can do this by just looking at the current win
    if type == 0
        call s:Verbose('not registering QfPos because this is not such a window')
        return
    endif
    if qf#type(winnr()) == type
        if type == 1
            let g:qf_lastPos = LastQfwinPos(winnr())
        elseif  type == 2
            let g:loc_lastPos = LastQfwinPos(winnr())
        endif 
    else
        call s:Verbose('not in a window of that type in RegisterQfPos(%1)', type)
    endif
endf

" This gets called for movements we want to do something about
fun! g:QfAdaptWinMovement(movement, currentState) abort
    call lh#assert#not_empty(a:currentState)
    
    if match(a:movement, '\v^[HJKL]$' >= 0)
        exec "wincmd ".a:movement
        " call s:Verbose('current state: %1', a:currentState)
        let hjklPrev = a:currentState.getHJKL()
        if match(a:movement, '\v^[HL]$') >= 0
            if !empty(hjklPrev)
                if hjklPrev == HJKLComplement(a:movement)
                    exec "vertical resize ".a:currentState.width
                    return
                endif
            endif
        else
            CResize
        endif
    endif
endf
" Type is 1 for quickfix and 2 for loclist
fun! s:qfinit_fresh(type) abort
    if a:type == 1
        wincmd J
    elseif a:type == 2
        wincmd K
    endif
endf
" initialization behavior of qf expressed as a class method on WinInfo, the last registered or default state of the window
" newest_movement as optional arg; currently only wincmd HJKL is processed (keep same width etc)
fun! s:qfinit_from_this(type, ...) abort dict
    if a:type > 0
        let hjkl = self.getHJKL()
        if ! empty(hjkl)
            exec "wincmd " . hjkl
            if match(hjkl, '\v[JK]') >= 0
                CResize
            endif
            if match(hjkl, '\v[HL]') >= 0
                exec "vertical resize " . self.width
            endif
        else
            CResize
            " if not hjkl, then leave it to the default behavior of CResize (which is also defined here, upon work of others...)
        endif
    elseif a:type == 2
        " nothing
    endif
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
fun! OnQfFiletype() abort
    call QfPositioningHook()
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
