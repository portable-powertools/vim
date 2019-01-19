let s:k_script_name = expand('<sfile>:p')
if !exists('s:verbose')
    let s:verbose = get(s:, 'verbose', 0)
endif
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
call QfVerbose(0)

"""""""""""""""""""""""
"  debugging with QF  "
"""""""""""""""""""""""

" selfmade qf height ctrl
if !exists('g:qf_wh')
    let g:qf_wh = 15
endif

if !exists('g:msgLastEnd')
    let msgLastEnd = -1
endif
command! -nargs=0 MessagesLast cope | Messages | exec "normal G" | let msgRecent = min([msgLastEnd + 1, line('$')]) | if msgLastEnd < line('$') | call FlashLines(msgRecent, line('$'), 2, 150) | endif | let msgLastEnd = line('$') | exec "silent! normal :".(msgRecent)."\<CR>" | wincmd p
" exec "normal \<Leader>cp"
command! -count=1 WTF call lh#exception#say_what(<count>)
nmap <silent> <F10>W :MessagesLast<CR>
nmap <silent> <F10>ww :exec '1WTF'<CR>
nmap <silent> <F10>w2 :exec '2WTF'<CR>
nmap <silent> <F10>w3 :exec '3WTF'<CR>
nmap <silent> <F10>w4 :echo v:count1<CR>
nnoremap <Leader><Leader>d :messages<CR>
map <Leader>cn <Plug>QuickFixNote
map <F10>__qfs <Plug>QuickFixSave

""""""""""""""""""""""""""
"  the convenience maps  "
""""""""""""""""""""""""""

command! -nargs=0 QSort call s:SortUniqQFList()
command! -nargs=1 RejectExt RejectName .<args>$
command! -nargs=1 KeepExt KeepName .<args>$
command! -nargs=1 KeepName call g:WithVar('g:qf_bufname_or_text', 1, 'Keep '.<q-args>)
command! -nargs=1 KeepCont call g:WithVar('g:qf_bufname_or_text', 2, 'Keep '.<q-args>)
command! -nargs=1 KeepBoth call g:WithVar('g:qf_bufname_or_text', 0, 'Keep '.<q-args>)
command! -nargs=1 RejectName call g:WithVar('g:qf_bufname_or_text', 1, 'Reject '.<q-args>)
command! -nargs=1 RejectCont call g:WithVar('g:qf_bufname_or_text', 2, 'Reject '.<q-args>)
command! -nargs=1 RejectBoth call g:WithVar('g:qf_bufname_or_text', 0, 'Reject '.<q-args>)
command! -bar -nargs=0 CResize call g:QFResizeGlobal()

command! -nargs=0 QCd let g:qflistbase = getcwd() . '/.qf' | echo printf('Quickfix register dir is now %s', g:qflistbase)
command! -nargs=0 QShow exec 'e '.g:qflistbase.'/'

nmap <Leader>crr :call qf#switch(1,1,0)<bar>CResize<bar>exec "normal ggG" <bar> call qf#switch(1,0,0)<CR>
nmap <Leader>arr :call qf#switch(2,1,1)<bar>CResize <bar>exec "normal ggG" <bar> wincmd p<CR>

nmap <Leader>c: :call :<C-u>call RegisterQfPos()<CR><Plug>(qf_qf_toggle)
nmap <Leader>c; :call :<C-u>call RegisterQfPos()<CR><Plug>(qf_qf_toggle_stay)
nmap <Leader>a: :call :<C-u>call RegisterQfPos()<CR><Plug>(qf_loc_toggle)
nmap <Leader>a; :call :<C-u>call RegisterQfPos()<CR><Plug>(qf_loc_toggle_stay)


nmap <Leader>cp :<C-u>call RegisterQfPos()<CR>:<C-u>call qf#switch(1, 1, 0)<CR>
" use only the precise loc list
nmap <Leader>ap :<C-u>call RegisterQfPos()<CR>:<C-u>call qf#switch(2, 1, 1)<CR>
" use any loc list if the precise one is not found
nmap <Leader>aP :<C-u>call RegisterQfPos()<CR>:<C-u>call qf#switch(2, 1, 0)<CR>

nmap <Leader>ced <Plug>Qflistsplit
nmap <Leader>aed <Plug>Loclistsplit

noremap <Leader>aaj :ALENext<CR>
nnoremap <Leader>aak :ALEPrevious<CR>
nmap <Leader>cj <Plug>(qf_qf_next)
nmap <Leader>ck <Plug>(qf_qf_previous)
nmap <Leader>aj <Plug>(qf_loc_next)
nmap <Leader>ak <Plug>(qf_loc_previous)

fun! RegisterQfMaps() abort
    nmap <silent><buffer> <Leader>m :.cc <bar> call g:FlashCurrentLine(1, 400) <bar> wincmd p<CR>
    nmap <silent><buffer> J j:.cc <bar> call g:FlashCurrentLine(2, 150) <bar> wincmd p<CR>
    nmap <silent><buffer> K k:.cc <bar> call g:FlashCurrentLine(2, 150) <bar> wincmd p<CR>

    nmap <buffer> o :<C-u>let loc_item = line('.') <bar> call qf#switch(1, 0, 0) <bar> sp <bar> exec loc_item.'cc'<CR>
    nmap <buffer> a :<C-u>let loc_item = line('.') <bar> call qf#switch(1, 0, 0) <bar> vs <bar> exec loc_item.'cc'<CR>
    nmap <buffer> O :<C-u>let loc_item = line('.') <bar> call qf#switch(1, 0, 0) <bar> sp <bar> exec loc_item.'cc' <bar> call qf#switch(1, 0, 0)<CR>
    nmap <buffer> O :<C-u>let loc_item = line('.') <bar> call qf#switch(1, 0, 0) <bar> vs <bar> exec loc_item.'cc' <bar> call qf#switch(1, 0, 0)<CR>
    nmap <buffer> <C-m> :<C-u>let loc_item = line('.') <bar> call qf#switch(1, 0, 0) <bar> exec loc_item.'cc'<CR>

    nmap <buffer> <Leader><Leader><Space> :<C-u>call RegisterQfPos()<CR>
    nmap <buffer> <Leader>x :<C-u>call RegisterQfPos()<CR>:<C-u>call qf#switch(1, 0, 0) <bar> cclose <CR>
    nmap <buffer> <Leader><Leader>x :let g:qf_lastPos = {} <bar> call qf#switch(1, 0, 0) <bar> cclose <CR>

    nmap <buffer> <Leader>c; <Leader>x
    " nmap <buffer> <C-w>p :<C-u>call qf#switch(1, 0, 0)<CR>

    nmap <buffer> <silent> u :silent! colder<CR>
    nmap <buffer> <silent> <C-r> :silent! cnewer<CR>
    
    nnoremap <buffer> yy :call g:YankQF(g:QFFileAndMod(v:register)) <bar> CResize<CR>
    nnoremap <buffer> pp :call RegisterQfPos() <bar> call g:PutQF(g:QFFileAndMod(v:register), 'forceAdd') <bar> call QfContentChanged()<CR>
    nnoremap <buffer> PP :call RegisterQfPos() <bar> call g:PutQF(g:QFFileAndMod(v:register), 'forceAdd', 'P') <bar> call QfContentChanged()<CR>
    nnoremap <buffer> <silent> <Leader>up :call RegisterQfPos() <bar> silent! call g:QfMergeWithOlder() <bar> call QfContentChanged()<CR>
    nnoremap <buffer> <silent> <Leader>uP :call RegisterQfPos() <bar> silent! call g:QfMergePWithOlder() <bar> call QfContentChanged()<CR>

    nnoremap <silent> <buffer> dae :call RegisterQfPos() <bar> :cexpr []<CR>

endf
fun! RegisterLocMaps() abort
    nmap <silent><buffer> <Leader>m :.ll <bar> call g:FlashCurrentLine(1, 400) <bar> wincmd p<CR>
    nmap <silent><buffer> J j:.ll <bar> call g:FlashCurrentLine(2, 150) <bar> wincmd p<CR>
    nmap <silent><buffer> K k:.ll <bar> call g:FlashCurrentLine(2, 150) <bar> wincmd p<CR>

    nmap <buffer> o :<C-u>let loc_item = line('.') <bar> call qf#switch(2, 0, 0) <bar> sp <bar> exec loc_item.'ll'<CR>
    nmap <buffer> a :<C-u>let loc_item = line('.') <bar> call qf#switch(2, 0, 0) <bar> vs <bar> exec loc_item.'ll'<CR>
    nmap <buffer> O :<C-u>let loc_item = line('.') <bar> call qf#switch(2, 0, 0) <bar> sp <bar> exec loc_item.'ll' <bar> wincmd p <bar> call qf#switch(2, 0, 0)<CR>
    nmap <buffer> A :<C-u>let loc_item = line('.') <bar> call qf#switch(2, 0, 0) <bar> vs <bar> exec loc_item.'ll' <bar> wincmd p <bar> call qf#switch(2, 0, 0)<CR>
    nmap <buffer> <C-m> o
    nnoremap <buffer> <Leader><C-m> <C-m>
    nmap <buffer> <Leader><C-m> :<C-u>let loc_item = line('.') <bar> call qf#switch(2, 0, 0) <bar> exec loc_item.'ll'<CR>

    " nmap <buffer> <C-w>p <Plug>(qf_loc_switch) " location lists in pairs..
    nmap <buffer> <Leader><Leader><Space> :<C-u>call RegisterQfPos()<CR>
    nmap <buffer> <Leader>x :<C-u>call RegisterQfPos()<CR>:lclose<CR>
    nmap <buffer> <Leader><Leader>x :let g:loc_lastPos = {} <bar> call qf#switch(2, 0, 0) <bar> lclose <CR>

    nnoremap <buffer> yy :call g:YankQF(g:QFFileAndMod(v:register)) <bar> CResize<CR>

    nmap <buffer> <Leader>a; <Leader>x
    " nmap <buffer> <C-w>p :<C-u>call qf#switch(2, 0, 0)<CR>

    nmap <buffer> <silent> u :silent! lolder<CR>
    nmap <buffer> <silent> <C-r> :silent! lnewer<CR>

    nnoremap <silent> <buffer> dae :call RegisterQfPos() <bar> lexpr []<CR>
endf
fun! RegisterGeneralMaps() abort
    nmap <buffer> <C-w>H :<C-u>call g:QfAdaptWinMovement('H', QfWinState())<CR>
    nmap <buffer> <C-w>J :<C-u>call g:QfAdaptWinMovement('J', QfWinState())<CR>
    nmap <buffer> <C-w>K :<C-u>call g:QfAdaptWinMovement('K', QfWinState())<CR>
    nmap <buffer> <C-w>L :<C-u>call g:QfAdaptWinMovement('L', QfWinState())<CR>
    nmap <buffer> <C-w><Space> :call RegisterQfPos()<CR>
    nmap <C-w>9 :<C-u>vertical resize 90 <bar> call RegisterQfPos()<CR>
    nmap <C-w>0 :<C-u>vertical resize 120 <bar> call RegisterQfPos()<CR>
    nmap <C-w>1 :<C-u>vertical resize 150 <bar> call RegisterQfPos()<CR>
    nnoremap <buffer> <Leader>S :QSort<CR>
    nnoremap <buffer> <Leader>e 0f<bar>T."zyt<bar>:KeepExt <C-r>z<CR>
    nnoremap <buffer> <Leader>rn 0"zyt<bar>:RejectName \V<C-r>z<CR>
    nnoremap <buffer> <Leader>re 0f<bar>F.l"zyt<bar>:RejectExt <C-r>z<CR>
    vnoremap <buffer> <Leader>R "zy:<C-u>Reject \V<C-r>z<CR>
    vnoremap <buffer> <Leader>rn "zy:<C-u>RejectName \V<C-r>z<CR>
endf


"""""""""""""""""""""""""""""""
"  Plugin settings, volatile  "
"""""""""""""""""""""""""""""""


" Plugin: qf plugin settings
let g:qf_max_height = 20 " should be overruled by vim-qf_resize if qf.vim is not set to autoresize
let g:qf_window_bottom = 0 " should be overruled by vim-qf_resize if qf.vim is not set to autoresize
let g:qf_loclist_window_bottom = 0 " should be overruled by vim-qf_resize if qf.vim is not set to autoresize

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


"""""""""""""""""""""
"  various helpers  "
"""""""""""""""""""""
function! s:CompareQuickfixEntries(i1, i2)
  if bufname(a:i1.bufnr) == bufname(a:i2.bufnr)
    return a:i1.lnum == a:i2.lnum ? 0 : (a:i1.lnum < a:i2.lnum ? -1 : 1)
  else
    return bufname(a:i1.bufnr) < bufname(a:i2.bufnr) ? -1 : 1
  endif
endfunction
function! s:SortUniqQFList()
  let sortedList = sort(getqflist(), 's:CompareQuickfixEntries')
  let uniqedList = []
  let last = ''
  for item in sortedList
    let this = bufname(item.bufnr) . "\t" . item.lnum
    if this !=# last
      call add(uniqedList, item)
      let last = this
    endif
  endfor
  call setqflist(uniqedList)
endfunction

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
    let type = qf#type(winnr())
    call lh#assert#true(type > 0)
    if type == 1
        if !empty(g:qf_lastPos)
            call g:qf_lastPos.qfinit_from_this(type)
        else
            call s:qfinit_fresh(type)
        endif
    endif
    if type == 2
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
        if empty(g:qf_lastPos)
            return QfWinState()
        endif
        return g:qf_LastPos
    elseif type == 2
        if empty(g:loc_lastPos)
            return QfWinState()
        endif
        return g:loc_lastPos
    endif
endf
fun! QfWinState(...) abort
    let s = GetWinInfo(get(a:, 1, winnr()))
    call lh#object#inject_methods(s, s:k_script_name, 'qfinit_from_this')
    return s
endf
fun! RegisterQfPos() abort
    let type = qf#type(winnr())
    call s:Verbose('called reqqpos type = %1', type)
    call s:Verbose('registerqfpos type: %1', type)
    
    "TODOitclean: now, I am assuming we can do this by just looking at the current win
    if type == 0
        call s:Verbose('not registering QfPos because this is not such a window')
        return
    endif
    if type > 0
        if type == 1
            let g:qf_lastPos = QfWinState()
        elseif  type == 2
            let g:loc_lastPos = QfWinState()
        endif 
    else
        call s:Verbose('not in a window of that type in RegisterQfPos(%1)', type)
    endif
endf

" This gets called for movements we want to do something about
fun! g:QfAdaptWinMovement(movement, currentState) abort
    call lh#assert#not_empty(a:currentState)
    
    echom string(a:currentState)
    if match(a:movement, '\v^[HJKL]$' >= 0)
        exec "wincmd ".a:movement
        " call s:Verbose('current state: %1', a:currentState)
        let hjklPrev = a:currentState.getHJKL()
        if match(a:movement, '\v^[HL]$') >= 0
            if !empty(hjklPrev)
                let complement = HJKLComplement(a:movement)
                if hjklPrev == complement
                    exec "vertical resize ".a:currentState.width
                    return
                endif
            endif
        else
            CResize
        endif
    endif

    call RegisterQfPos()
endf

fun! QfContentChanged() abort
    call lh#assert#true(qf#type(winnr()) > 0)
    
" TODO: implement that
    if match(QfWinState().getHJKL(), '[HL]') == -1
        CResize
    endif
endf

" Type is 1 for quickfix and 2 for loclist
fun! s:qfinit_fresh(type) abort
    if a:type == 1
        call ExecNormalWincmd('K')
        CResize
    elseif a:type == 2
        call ExecNormalWincmd('J')
        CResize " resize when default vertical-open behavior
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
    call QfRegisterMappings()
    call QfPositioningHook()
endf
augroup QfPosSimlei
    autocmd!
    autocmd FileType qf call OnQfFiletype()
    " autocmd! * <buffer>
    " exec ''
augroup end

fun! g:QFResizeGlobal() abort
    
    " let w1 = winnr()
    " let w2 = winnr('#')
    " echo qf#getWinInfos([1,2])
    " call qf#OnEach([1,2], { w -> w.vertResize(1, 1, 2, 0)})
    " call qf#OnEach([1,2], { w -> w.vertResize(1, g:qf_wh, 2, 0)})
    " exec w2.'wincmd w'
    " exec w1.'wincmd w'

    if qf#type(winnr()) > 0
        call GetWinInfo().vertResize(1, g:qf_wh, 2, 0)
    endif
    " if qf#IsQfWindowOpen() 
    "     for winnum in range(1, winnr('$'))
    "         let height = 1
    "         if qf#IsQfWindow(winnum)
    "             let height = getwininfo(win_getid(winnum))[0]['height']
    "         endif
    "     endfor
    "     let switchBack = 0
    "     if qf#IsQfWindow(winnr())
    "         let switchBack = 1
    "         exec "normal \<Plug>(qf_qf_switch)"
    "     endif
    "     if ! GetWinInfo().isFullHeight()
    "         QfResizeWindows " blueyed impl.
    "     endif
    "     if switchBack == 1
    "     QFResizeGlobal
    "         exec "normal \<Plug>(qf_qf_switch)"
    "     endif

    "     " Legacy: with vim-qf stuff
    "     " let max_height = get(g:, 'qf_max_height', 10) < 1 ? 10 : get(g:, 'qf_max_height', 10) 
    "     " if height <= max_height || 1 " TODO: always resize... get it to work that qf doesnt maximize nor reopens vertically
    "     "     if qf#IsQfWindow(winnr())
    "     "         let switchBack = 0
    "     "         " call feedkeys("\<Plug>(qf_qf_switch)", 'x') 
    "     "         exec "normal \<Plug>(qf_qf_switch)"
    "     "     else
    "     "         let switchBack = 1
    "     "     endif
    "     "     execute get(g:, "qf_auto_resize", 1) ? 'cclose|' . min([ max_height, len(getqflist()) ]) . 'cwindow' : 'cwindow'
    "     "     if switchBack == 1
    "     "         exec "normal \<Plug>(qf_qf_switch)"
    "     "     endif
    "     " endif
    " endif
endf

let g:currentQFListCanon = 'default'

"""""""""""""""""""""""""""""""""
"  QFRegisters and named lists  "
"""""""""""""""""""""""""""""""""

if ! exists('g:qflistbase')
    let g:qflistbase = getcwd(-1) . '/.qf'
endif

" flags: 'forceAdd', 'P', 'changeCanon'
fun! g:PutQF(spec, ...) abort
    let [f, canon, isUp] = a:spec
    let modeOfPut = 'replace' " append, prepend
    let success = 0

    if index(a:000, 'P') != -1
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
            exec 'QflA '.f
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
        return [g:qflistbase.'/'.canon.'.qflist', canon, isUp]
    else
        throw "no alpha character for g:QFFileAndMod: ". a:char
    endif
endf
fun! g:QFFile(char) abort
    return g:QFFileAndMod(a:char)[0]
endf


command! -nargs=1 QYank call YankQF(QFFileAndMod(<f-args>))

"" Proxy cmd for implementation. Current: kickfix native writing
command! -nargs=1 Qfw call KillBufIfExists(<f-args>) | w! <args>
command! -nargs=1 Qfl QLoad <args>
" append
command! -nargs=1 Qfla call g:QflaImpl(<f-args>)
" prepend
command! -nargs=1 QflA call g:QflAImpl(<f-args>)

" command! -nargs=1 EnsureQf if qf#type(winnr()) != 1 | call qf#switch(1,0,0) | endif | <args>


" qf.vim powered append-paste style
fun! g:QflaImpl(file) abort
    SaveList buf1
    exec "QLoad ".a:file
    call qf#switch(1, 0, 0)
    SaveList buf2
    LoadList buf1
    LoadListAdd buf2
endf
" qf.vim and kickfix powered prepend-paste style
fun! g:QflAImpl(file) abort
    SaveList buf1
    exec "QLoad ".a:file
    call qf#switch(1, 0, 0)
    LoadListAdd buf1
endf
fun! QfMergePWithOlder() abort
    colder
    SaveList buf1
    cnewer
    SaveList buf2
    LoadList buf1
    LoadListAdd buf2
endf
fun! QfMergeWithOlder() abort
    colder
    SaveList buf1
    cnewer
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
