set noequalalways

let s:k_script_name = expand('<sfile>:p')
let s:verbose = get(s:, 'verbose', 0)

function! WinVerbose(...)
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
call WinVerbose(1)

" Spacebar: express

" nmap <Space>c :call qf#switch(1,0,0)<CR>
" nmap <Space>a :call qf#switch(2,1,1)<CR>
" nmap <Space>A :call qf#switch(2,1,0)<CR>

" nmap <Space> <C-w>
" nmap <Space><Space> <C-w>p
" nmap ;<Space><Space> <C-w>P
" nmap <Space>, <C-w>p
" nmap <Space>; <C-w>P
" imap <F10><Space> <Esc><Space>

nmap <C-w><Up> :10CmdResizeUp<CR>
nmap <C-w><Down> :10CmdResizeDown<CR>
nmap <C-w><Left> :10CmdResizeLeft<CR>
nmap <C-w><Right> :10CmdResizeRight<CR>

nnoremap <silent> <c-left> :3CmdResizeLeft<cr>
nnoremap <silent> <c-down> :3CmdResizeDown<cr>
nnoremap <silent> <c-up> :3CmdResizeUp<cr>
nnoremap <silent> <c-right> :3CmdResizeRight<cr>

" Sizes
nmap <C-w>9 :<C-u>vertical resize 90<CR>
nmap <C-w>0 :<C-u>vertical resize 120<CR>
nmap <C-w>1 :<C-u>vertical resize 150<CR>
map gF "zyW:e <C-r>z<CR>

nnoremap <Leader><Leader><Leader>l :call g:MoveToNextTab()<CR>
nnoremap <Leader><Leader><Leader>h :call g:MoveToPrevTab()<CR>
nmap <Leader><Leader><Leader>L :sp<CR>:call g:MoveToNextTab()<CR>
nmap <Leader><Leader><Leader>H :sp<CR>:call g:MoveToPrevTab()<CR>

"""""""""""""""""""""""""""""""""""""""""""
"  fast splitting and moving and closing  "
"""""""""""""""""""""""""""""""""""""""""""
nmap <Leader>x :q<CR>
nmap <Leader>X :q!<CR>

nmap <F10>x :bdelete<CR>
nmap <F10>X :bdelete!<CR>
nmap <F10><F10>x :Bdelete<CR>
nmap <F10><F10>X :Bdelete!<CR>

" undo :q
let g:undoquit_mapping = '<C-w>u'
map <Leader><Leader>u <C-w>u
let g:tradewinds_no_maps = 1

" window movement
" swapping
nmap <Leader><Leader>j <C-w>j<C-w>:call g:WinBufSwap()<CR>
nmap <Leader><Leader>k <C-w>k<C-w>:call g:WinBufSwap()<CR>
nmap <Leader><Leader>l <C-w>l<C-w>:call g:WinBufSwap()<CR>
nmap <Leader><Leader>h <C-w>h<C-w>:call g:WinBufSwap()<CR>
" soft move (tradewinds plugin)
nmap <leader><Leader>H <plug>(tradewinds-h)
nmap <leader><Leader>J <plug>(tradewinds-j)
nmap <leader><Leader>K <plug>(tradewinds-k)
nmap <leader><Leader>L <plug>(tradewinds-l)
" simply splitting the same buffer in the 4 directions (2 dir + stay or move)
nmap <Leader>j :sp<CR>
nmap <Leader>k :sp<CR><C-w>k
nmap <Leader>l :vs<CR>
nmap <Leader>h :vs<CR><C-w>h
" -- and deleting in 4 directions
nmap <Leader>H <C-w>h:call OnThisWinFromPrev('wincmd q')<CR>
nmap <Leader>J <C-w>j:call OnThisWinFromPrev('wincmd q')<CR>
nmap <Leader>K <C-w>k:call OnThisWinFromPrev('wincmd q')<CR>
nmap <Leader>L <C-w>l:call OnThisWinFromPrev('wincmd q')<CR>
    tmap <Leader><Leader>j <C-w>j<C-w>:call g:WinBufSwap()<CR>
    tmap <Leader><Leader>k <C-w>k<C-w>:call g:WinBufSwap()<CR>
    tmap <Leader><Leader>l <C-w>l<C-w>:call g:WinBufSwap()<CR>
    tmap <Leader><Leader>h <C-w>h<C-w>:call g:WinBufSwap()<CR>
    tmap <leader><Leader>H <C-w>N<plug>(tradewinds-h)i
    tmap <leader><Leader>J <C-w>N<plug>(tradewinds-j)i
    tmap <leader><Leader>K <C-w>N<plug>(tradewinds-k)i
    tmap <leader><Leader>L <C-w>N<plug>(tradewinds-l)i
    " tmap <Leader>j <C-w>:sp<CR>
    " tmap <Leader>k <C-w>:sp<CR><C-w>k
    " tmap <Leader>l <C-w>:vs<CR>
    " tmap <Leader>h <C-w>:vs<CR><C-w>h
    tmap <Leader>H <C-w>h<C-w>:call OnThisWinFromPrev('wincmd q')<CR>
    tmap <Leader>J <C-w>j<C-w>:call OnThisWinFromPrev('wincmd q')<CR>
    tmap <Leader>K <C-w>k<C-w>:call OnThisWinFromPrev('wincmd q')<CR>
    tmap <Leader>L <C-w>l<C-w>:call OnThisWinFromPrev('wincmd q')<CR>

command! -nargs=0 ResetCWD exec 'cd '.getcwd(-1)
nmap <Leader>n :enew<CR>
nmap <Leader>N :enew<CR>:ResetCWD<CR>:pwd<CR>
nmap <F10>d? :echom 'pwd: '.getcwd().' <bar> -1wd: ' . getcwd(-1)<CR>
nmap <Leader>gcd :ResetCWD<CR>:pwd<CR>



" Mainwindow:
if !exists('g:mainWin')
    let g:mainWin = GetWinInfo(1)
endif
nmap <C-w>m :MainWinMark<CR>
nmap <C-w>g <F2>gg
nmap <C-w><Space> :MainWinSwitch<CR>
tmap <C-w><Space> <C-w>:MainWinSwitch<CR>

command! -bar -nargs=0 MainWinUpdate if exists('g:mainWin') && g:mainWin.exists() | let g:mainWin = g:mainWin.updated() | else | unlet! g:mainWin | endif
command! -bar -nargs=0 MainWinMark let g:mainWin = GetWinInfo()
command! -bar -nargs=0 MainWinClear let g:mainWin = GetWinInfo()
command! -bar -nargs=0 MainWinGo MainWinUpdate | call g:mainWin.jump()
command! -bar -nargs=0 MainWinSwitch MainWinUpdate | if exists('g:mainWin') && winnr() != g:mainWin.winnr | MainWinGo | else | wincmd p | endif

" Resizing:

nmap <Space>r :Shrink<CR>
nmap <Space>R :Resize<CR>

if !exists('g:shrinkInit')
    let g:shrinkInit = 15
endif
command! -nargs=0 Shrink call GetWinInfo().vertResize(1, g:shrinkInit, 1, 0)
command! -nargs=0 Resize PreserveWin call Resize_()

" Helper command
command! -nargs=1 PreserveWin call WithWinPreservedEval(<q-args>)

" Ordered list of commands to resize
let g:resizespec = [ 
            \ ['main', 'call GetNormalWincmd("_")'], 
            \ ['qf', 'CResize'],
            \ ['regular', 'Shrink']
            \]
" Resizing_Indexes:how the idxes are determined:
fun! ResizeRoutineIdx(winnr) abort
    let info = GetWinInfo(a:winnr)
    let mark = 'notouch'
    if info.isTerm()
        return mark
    endif
   
    let mark = 'qf'
    if info.qftype() > 0 
        return mark
    endif

    if g:mainWin.winid == info.winid
        return 'main'
    endif

    return 'regular'
endfun


" Choosewin -- mostly terminal compat
nmap  <C-w>;  <Plug>(choosewin)
tnoremap  <C-w>;  <C-w>:ChooseWin<CR>
let g:choosewin_overlay_enable = 0


" Directories:
" ,BufWinEnter,TabEnter
augroup cdprint
    au!
    autocmd WinEnter,TabEnter * call g:PwdEcho()
augroup end

if !exists('g:monitorPwd')
    let g:monitorPwd = 0
endif
nnoremap <F11>dir :let g:monitorPwd = ! g:monitorPwd <bar> echo 'g:monitorPwd toggled to: '.g:monitorPwd<CR>
fun! g:PwdEcho()
    if g:monitorPwd
        echom 'pwd: '.getcwd().' | -1wd: ' . getcwd(-1)
    endif
endf

"""""""""""""""""""""""
"  support functions  "
"""""""""""""""""""""""


fun! GetNormalWincmd(cmd, ...) abort
    let mycount=get(a:, 1, '')
    let fmt = "normal! %2\<C-w>%1"
    return lh#fmt#printf(fmt, a:cmd, mycount)
endf
fun! ExecNormalWincmd(cmd, ...) abort
    exec call('GetNormalWincmd', [a:cmd] + a:000)
endf


" gets a list of winnrs that are vertical from the main one, top to bottom
fun! WinsVert(...) abort
    let main = get(a:, 1, g:mainWin.nrNow())
    let mainInfo = GetWinInfo(main)
    call mainInfo.jump()
    
    let trace = []
    let current = main
    while 1
        call add(trace, current)
        call ExecNormalWincmd('k')
        
        let now = winnr()
        if now == current
            break
        endif
        let current = now
    endwhile
    call reverse(trace)
    call mainInfo.jump()
    call ExecNormalWincmd('j')
    let current = winnr()
    while current != main
        call add(trace, current)
        call ExecNormalWincmd('j')
        
        let now = winnr()
        if now == current
            break
        endif
        let current = now
    endwhile
    return trace
endf

fun! Resize_Sequence(...) abort
    let spec = get(a:, 1, g:resizespec)
    let trace = WinsVert() " default is mainwindow (now), result is [winnr, ...]
    let traceIdx = map(copy(trace), {i, t -> ResizeRoutineIdx(t)})
    let traceIdxed = lh#list#zip(traceIdx, trace)
    let traceDict = {}
    for [i, winnr] in traceIdxed
        if has_key(traceDict, i)
            let traceDict[i] = traceDict[i] + [winnr]
        else
            let traceDict[i] = [winnr]
        endif
    endfor
    
    let actions = []
    for [specidx, speccmd] in spec
        let winlist = get(traceDict, specidx, [])
        for winnr in winlist
            call add(actions, [winnr, speccmd])
        endfor
    endfor
    return actions
endf

fun! Resize_(...) abort
    let sequence = call('Resize_Sequence', a:000)
    for [winnr, cmd] in sequence
        call ExecNormalWincmd('w', winnr)
        exec cmd
    endfor
endf

fun! WithWinPreservedEval(cmd) abort
    let wdot = GetWinInfo()
    let whash = GetWinInfo(winnr('#'))
    try
        exec a:cmd
    catch /.*/
        echoerr v:exception
    finally
        let wdotnow = GetWinInfo()
        let whashnow = GetWinInfo(winnr('#'))
        if wdot.winid != wdotnow.winid || whash.winid != whashnow.winid
            exec "normal! ".win_id2win(whash.winid)."\<C-w>w"
            exec "normal! ".win_id2win(wdot.winid)."\<C-w>w"
        endif
    endtry

endf
fun! OnThisWinFromPrev(execstring) abort
    let curwin = winnr()
    wincmd p
        let pwin = winnr()
    let pwinid = win_getid(pwin)
    exec curwin.'wincmd w'
    exec a:execstring
    let nowpwin = win_id2win(pwinid)
    exec printf('%swincmd w', nowpwin)
endf


function! g:WinBufSwap()
  let thiswin = winnr()
  let thisbuf = bufnr("%")
  let lastwin = winnr("#")
  let lastbuf = winbufnr(lastwin)

  exec  lastwin . " wincmd w" ."|".
      \ "buffer ". thisbuf ."|".
      \ thiswin ." wincmd w" ."|".
      \ "buffer ". lastbuf
endfunction


function! g:MoveToPrevTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() != 1
    close!
    if l:tab_nr == tabpagenr('$')
      tabprev
    endif
    sp
  else
    close!
    exe "0tabnew"
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunc

function! g:MoveToNextTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() < tab_nr
    close!
    if l:tab_nr == tabpagenr('$')
      tabnext
    endif
    sp
  else
    close!
    tabnew
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunc
