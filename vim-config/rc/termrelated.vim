let g:is_bash = 1

command! -nargs=0 Term exe 'term '.g:Simleime_termcommand | . call g:TermMark()
command! -nargs=0 TermClear call g:Simleime_clear()
command! -nargs=0 TermClearTab call g:Simleime_clearTab()
command! -nargs=0 TermClearGlobal call g:Simleime_clearGlobal()
command! -nargs=0 Termls echom 'The tabscoped buffer is ' . g:GetOrDefault('t:Simleime_targetTermBuf', 'unset') . ', the global is ' . g:GetOrDefault('g:Simleime_targetTermBuf', 'unset') . "\nEffective target: " . g:Simleime_getTermBuf() . '; global-usage if no tabscoped found: ' . g:Simleime_useGlobalTerm . '; force-global: ' . g:Simleime_force_global_target


nnoremap <F11>termg :let g:Simleime_useGlobalTerm = ! g:Simleime_useGlobalTerm <bar> echo 'g:Simleime_useGlobalTerm toggled to: '.g:Simleime_useGlobalTerm<CR>
nnoremap <F11>termfg :let g:Simleime_force_global_target = ! g:Simleime_force_global_target <bar> echo 'g:Simleime_force_global_target toggled to: '.g:Simleime_force_global_target<CR>

fun! g:Make_Termsend_Map(regchar)
    if(a:regchar == 't')
        throw 'can''t map t here'
    endif
    execute 'nmap <Leader>t'.a:regchar.' "'.a:regchar.'<Leader>tr'
    execute 'tmap <F2>t'.a:regchar.' <C-w>:call g:TermMark() <bar> call g:Simleime_put_reg("'.a:regchar.'")<CR>'
    execute 'nnoremap <Leader>?'.a:regchar.' :echo @'.a:regchar.'<CR>'
endf

tnoremap <F10>tmark <C-w>:call g:TermMark()<CR>

" F4 is shortcut for f2g, navigation commands...
map <F4> <F2>g
tmap <F4> <F2>g
tmap <PageUp> <C-w>N
"
" shortcuts to go back and forth to the terminal and mark it in the process.
" last char m is make (open new), p is go back, f is go, selectmode and make
" bigger, g is just go
nmap <F2>gM :Term<CR>
tmap <F2>gm <C-w>:call g:TermMark()<CR>
tmap <F2>ggm <C-w>:call g:TermMarkGlobal()<CR>
nmap <F2>gg :call lh#buffer#find(g:Simleime_getTermBuf())<CR>
nmap <F2>gG <F2>gg<C-w>N
nmap <F2>gf <F2>gg<C-w>N<F10><Up><F10><Up>
tmap <F2>gf <C-w>N<F10><Up><F10><Up>
tmap <F2>gG <C-w>:call lh#buffer#find(g:Simleime_getTermBuf())<CR><C-w>N
tmap <F2>gp <F2>gm<C-w>p
nmap <F2>gp i<F2>gm
" close existing, make new term
nmap <silent> <F2>gn :if g:Simleime_hasTerm() <bar> let g:gobackhere=bufnr('%') <bar> exe 'Tp exit' <bar> call lh#buffer#find(g:Simleime_getTermBuf()) <bar> if bufnr('%') == g:Simleime_getTermBuf() <bar> exe "q" <bar> call lh#buffer#find(g:gobackhere) <bar> endif <bar> endif <bar> execute "normal \<F2>gm\<F2>gp" <CR>
nmap <silent> <F2>gx :if g:Simleime_hasTerm() <bar> let g:gobackhere=bufnr('%') <bar> exe 'Tp exit' <bar> call lh#buffer#find(g:Simleime_getTermBuf()) <bar> if bufnr('%') == g:Simleime_getTermBuf() <bar> exe "bdelete!" <bar> call lh#buffer#find(g:gobackhere) <bar> endif <bar> endif <bar> <CR>
tmap <silent> <F2>gx <F2>gp:if g:Simleime_hasTerm() <bar> let g:gobackhere=bufnr('%') <bar> exe 'Tp exit' <bar> call lh#buffer#find(g:Simleime_getTermBuf()) <bar> if bufnr('%') == g:Simleime_getTermBuf() <bar> exe "bdelete!" <bar> call lh#buffer#find(g:gobackhere) <bar> endif <bar> endif <bar> <CR>
" tmap <F2>gp <C-w>p
" nmap <F2>gp i<C-w>p

" Resize term windows
tmap <F10><Up> <C-w>:resize +8<CR>
tmap <F10><Down> <C-w>:resize -8<CR>
tmap <F10><Left> <C-w>:vertical resize +8<CR>
tmap <F10><Right> <C-w>:vertical resize -8<CR>
nmap <F10><Up> :resize +8<CR>
nmap <F10><Down> :resize -8<CR>
nmap <F10><Left> :vertical resize +8<CR>
nmap <F10><Right> :vertical resize -8<CR>

call g:Make_Termsend_Map('u')
call g:Make_Termsend_Map('i')
call g:Make_Termsend_Map('o')
call g:Make_Termsend_Map('p')
nnoremap <Leader>th :<C-u>call g:Simleime_put(g:Simleime_hists(v:count1, v:count1-1))<CR>
nnoremap <Leader>Th :<C-u>call g:Simleime_put(g:Simleime_thists(v:count1, v:count1-1))<CR>
nnoremap <Leader>tch :THC<CR>
nnoremap <Leader>tls :echo "send-history:\n".join(g:Simleime_hist(5), "\n======\n")<CR>
nnoremap <Leader>Tls :echo "term-history:\n".join(g:Simleime_thist(10), "\n")<CR>
" send registers  (clipboard by default), big R is no newline
nnoremap <Leader>tr :call g:Simleime_put_reg(v:register)<CR>
nnoremap <Leader>tR :call g:Simleime_put_reg(v:register, 0)<CR>
" fetch: from send or cmd history into arbitrary reg, takes hist. count with
" default being 1 (last)
nnoremap <Leader>tf :<C-u>call g:Simleime_fetch_reg('h', v:register, v:count1)<CR>
nnoremap <Leader>Tf :<C-u>call g:Simleime_fetch_reg('t', v:register, v:count1)<CR>


"send entire buffer content
nmap <F2>e vae<F2>j

nnoremap <F2>f; :call g:Simleime_toggleTargetfile()<CR>
nnoremap <F2>fls :call g:Simleime_echoTargetfile()<CR>
map <F2>fm :call g:Simleime_put('"'.g:Simleime_targetfile_get().'"'."\n")<CR>
map <F2>fp :call g:Simleime_put('"'.g:Simleime_targetfile_get().'"')<CR>
map <F2>fs :call g:Simleime_put('source '.'"'.g:Simleime_targetfile_get().'"'."\n")
map <Leader>ttfr :call g:Simleime_put(getreg(v:register).' "'.g:Simleime_targetfile_get().'"'."\n")<CR>
map <Leader>ttfR :call g:Simleime_put('"'.g:Simleime_targetfile_get().'" '.getreg(v:register)."\n")<CR>


vnoremap <F2>l :<C-u>call g:Simleime_put(g:Strip_space(Get_visual_selection()))<CR>
vnoremap <F2>j :<C-u>call g:Simleime_put(g:Strip_space(Get_visual_selection())."\n")<CR>

tnoremap <F2>kj <C-w>:call g:Simleime_put_repeated(Simleime_hists(1))<CR>

nnoremap <F2>j :call g:Simleime_put(g:Strip_space(getline('.'))."\n")<CR>
nnoremap <F2>J :call g:Simleime_put(g:Strip_space(getline('.')))<CR>
nnoremap <F2>kj :call g:Simleime_put_repeated(Simleime_hists(1))<CR>
nnoremap <F2>kJ :call g:Simleime_put_repeated(Simleime_thists(1))<CR>
nnoremap <F2>kl :call g:Simleime_put(Strip_space(Simleime_hists(1)))<CR>
nnoremap <F2>kL :call g:Simleime_put(Strip_space(Simleime_thists(1)))<CR>
nnoremap <F2><Space> :call g:Simleime_put(" ")<CR>
nnoremap <F2>m :call g:Simleime_put("\n")<CR>
nnoremap <F2>w "zyiw:call g:Simleime_put_reg('z', 0)<CR>
nnoremap <F2>W "zyiW:call g:Simleime_put_reg('z', 0)<CR>
" nnoremap <F2>n :call g:Simleime_put(" \| ")<CR>
nnoremap <F2>p :call g:Simleime_put(g:Strip_space(@"))<CR>
" nnoremap <F2>v :call g:Simleime_put(g:Strip_space(@+))<CR>
nnoremap <F2>c :call g:Simleime_put(g:cckey)<CR>
let g:cckey = "\<C-c>"


" =============================================
" scripts

" ------- variables

if ! exists('g:Simleime_termcommand')
    let g:Simleime_termcommand='bash'
endif
if ! exists('g:Simleime_targetfile')
    let g:Simleime_targetfile=''
endif
if ! exists('g:Simleime_sent')
    let g:Simleime_sent = []
endif
if ! exists('g:Simleime_force_global_target')
    let g:Simleime_force_global_target=0
endif

" ------- commands

" takes optional source (default h, alt: t), reg, count, skipafter
command! -nargs=* Tfr call g:Simleime_fetch_reg('h', <f-args>)
command! -nargs=* TFr call g:Simleime_fetch_reg('t', <f-args>)
" takes optional reg and newline-append; default " and 1 (newline append yes)
command! -nargs=* Tpr call g:Simleime_put_reg(<f-args>)
command! -nargs=+ TP call g:Simleime_put(<q-args>."")
command! -nargs=* Tp call g:Simleime_put(<q-args>."\n")

command! -nargs=+ GTP let g:Simleime_backupForceGlobal=g:Simleime_force_global_target | let g:Simleime_force_global_target = 1 | exe 'TP '.<q-args> | let g:Simleime_force_global_target=g:Simleime_backupForceGlobal
command! -nargs=* GTp let g:Simleime_backupForceGlobal=g:Simleime_force_global_target | let g:Simleime_force_global_target = 1 | exe 'Tp '.<q-args> | let g:Simleime_force_global_target=g:Simleime_backupForceGlobal

command! -nargs=0 THC let g:Simleime_sent=[]


" new

fun! g:Simleime_hasTerm()
    if Simleime_getTermBuf() == -1
        return 0
    else
        return 1
    endif
endf

" ======= targetfile

fun! g:Simleime_targetfile_get()
    if g:Simleime_targetfile != ''
        return g:Simleime_targetfile
    endif
    return expand('%:p')
endf
fun! g:Simleime_toggleTargetfile()
    if g:Simleime_targetfile == ''
        let g:Simleime_targetfile = expand('%:p')
        echo 'Simleime_targetfile is now'.g:Simleime_targetfile
    else
        let g:Simleime_targetfile = ''
        echo 'cleared marked file'
    endif
endf
fun! g:Simleime_echoTargetfile()
    if g:Simleime_targetfile == ''
        echo 'no marked file'
    else
        echo 'Simleime_targetfile is '.g:Simleime_targetfile
    endif
endf




" optional arguments:
" alternative_source: default h (sent history), t for terminal command hist
" reg: default "
" count: how many
" skip: number to skip of the pulled (freshest)
fun! g:Simleime_fetch_reg(...)
    let l:source = get(a:, 1, 'h')
    let l:reg = get(a:, 2, '"')
    let l:count = get(a:, 3, 1)
    let l:skip = get(a:, 4, 0)
    
    let l:payload = g:Simleime_hists(l:count, l:skip)
    if l:source == 't'
        let l:payload = g:Simleime_thists(l:count, l:skip)
    endif

    call setreg(l:reg, l:payload)
endf

" takes optional newline-append argument, but only useful when '0' - \n is appendedby default
fun! g:Simleime_put_reg(...)
    let l:reg = get(a:, 1, '"')
    let l:newline = get(a:, 2, 1)
    if l:reg == ''
        let l:payload = getreg('"')
    else
        let l:payload = getreg(reg)
    endif
    let l:payload = g:Strip_space(l:payload)
    if l:newline
        let l:payload = l:payload."\n"
    endif
    call Simleime_put(l:payload)
endf


function! s:MakeHistCmd(nr)
    let s:result=printf('history | sed ''s/^\s*[0-9]*\s*//g'' | egrep -v ''^history'' | tail -n %d', a:nr)
    return s:result
endfunction

fun! s:MyTermRead(cmd)
    let l:clippipe=get(a:, 1, 'xclip -selection clipboard')
    let l:tempfile = tempname()
    let l:filepipe = 'cat > '.l:tempfile
    let l:amendedCmd = a:cmd . ' | ' . l:filepipe
    call MyTermSend(l:amendedCmd."\r")
    sleep 100m
    if filewritable(l:tempfile)
        let l:result =  readfile(l:tempfile)
        exe system('rm "'.l:tempfile.'"')
        return l:result
    else
        echoerr 'could not read output file from terminal for command '.a:cmd
        return printf('echo <error on %s>', a:cmd)."\n"
    endif
endf
fun! g:CmdlistAsString(list)
    return join(a:list, "\n")."\n"
endf
fun! g:Simleime_hists(nr, ...)
    let l:skipnr = get(a:, 1, 0)
    let l:result = g:Simleime_hist(a:nr)
    let l:result = l:result[:len(l:result)-l:skipnr-1]
    return g:CmdlistAsString(l:result)
endf
fun! g:Simleime_thists(nr, ...)
    let l:skipnr = get(a:, 1, 0)
    let l:result = g:Simleime_thist(a:nr)
    let l:result = l:result[:len(l:result)-l:skipnr-1]
    return g:CmdlistAsString(l:result)
endf
fun! g:Simleime_thist(...)
    let l:nr = get(a:, 1, 999999)
    let l:histresult = s:MyTermRead(s:MakeHistCmd(l:nr))
    return l:histresult
endf
" optional aarg: tail length
fun! g:Simleime_hist(...)
    let l:nr = get(a:, 1, 999999)
    if !exists('g:Simleime_sent')
        return []
    endif
    let s:start = max([ 0, len(g:Simleime_sent)-l:nr ])
    let s:resList=g:Simleime_sent[s:start:]
    return s:resList
endf
fun! s:RegisterCmd(cmd)
    if !exists('g:Simleime_sent')
        let g:Simleime_sent = []
    endif 
    
    let g:Simleime_sent=add(g:Simleime_sent, g:Strip_space(a:cmd))
    let g:Simleime_sentDangling = ''
endf
fun! g:Simleime_put(payload)
    if exists('g:Simleime_sentDangling')
        let g:Simleime_sentDangling = g:Simleime_sentDangling.a:payload
    else
        let g:Simleime_sentDangling = a:payload
    endif
    if g:Simleime_sentDangling =~ "\\n$"
        if s:shouldAppendToHist(g:Simleime_sentDangling)
            call s:RegisterCmd(g:Simleime_sentDangling)
        endif
        let g:Simleime_sentDangling = ''
    endif
    call MyTermSend(a:payload)
endf

let g:Simleime_putback_mem = 1
let g:Simleime_put_minlength = 3
fun! s:shouldAppendToHist(cmd)
    if (len(a:cmd) < g:Simleime_put_minlength)
        return 0 
    endif
    let l:idx = index(g:Simleime_hist(g:Simleime_putback_mem), g:Strip_space(a:cmd))
    if(l:idx >= 0)
        return 0
    endif
    return 1
endf
fun! g:Simleime_put_repeated(payload)
    call MyTermSend(a:payload)
endfun

function! MyTermSend(payload)
    let l:target = g:Simleime_getTermBuf()
    if bufexists(l:target)
        call term_sendkeys(l:target, a:payload)
    else
        echo 'no terminal to send to...'
    endif
endfunction
function! g:TermMark()
    if getbufvar(bufnr('%'), '&buftype', 'ERROR') != 'terminal'
        call xolox#misc#msg#warn('not a terminal buffer')
        return 0
    endif
    let t:Simleime_targetTermBuf=bufnr('%')
    " let g:Simleime_targetTermWin=winnr()
    " echo 'target terminal is nr. ' . t:Simleime_targetTermBuf
endfunction
function! g:TermMarkGlobal()
    if getbufvar(bufnr('%'), '&buftype', 'ERROR') != 'terminal'
        call xolox#misc#msg#warn('not a terminal buffer')
        return 0
    endif
    let g:Simleime_targetTermBuf=bufnr('%')
    " let g:Simleime_targetTermWin=winnr()
    " echo 'target terminal is nr. ' . t:Simleime_targetTermBuf
endfunction

fun! g:Simleime_clearGlobal()
    unlet g:Simleime_targetTermBuf
endf
fun! g:Simleime_clearTab()
    unlet t:Simleime_targetTermBuf
endf
fun! g:Simleime_clear()
    call g:Simleime_clearTab()
    call g:Simleime_clearGlobal()
endf

let g:Simleime_useGlobalTerm=0
fun! g:Simleime_getTermBuf()
    if g:Simleime_force_global_target || ! exists('t:Simleime_targetTermBuf') || ! bufexists(t:Simleime_targetTermBuf) || getbufvar(t:Simleime_targetTermBuf, '&buftype', 'ERROR') != 'terminal'
        " global target ...
        if g:Simleime_force_global_target
            if ! exists('g:Simleime_targetTermBuf') || ! bufexists(g:Simleime_targetTermBuf) || getbufvar(g:Simleime_targetTermBuf, '&buftype', 'ERROR') != 'terminal'
                call xolox#misc#msg#warn('forcing global terminal target is on, but the terget buffer doesnt seem right. Look up :Termls')
                return -1
            else
                return g:Simleime_targetTermBuf
            endif
        endif
        if g:Simleime_useGlobalTerm == 0 || ! exists('g:Simleime_targetTermBuf') || ! bufexists(g:Simleime_targetTermBuf) || getbufvar(g:Simleime_targetTermBuf, '&buftype', 'ERROR') != 'terminal'
            call xolox#misc#msg#warn('No tabscoped termbuf found and no global -- or not configured to be used (g:Simleime_useGlobalTerm is 0) - see :Termls')
            return -1
        else
            call xolox#misc#msg#info('In lieu of tab-scoped term buf, using the global one #:' . g:Simleime_targetTermBuf)
            return g:Simleime_targetTermBuf
        endif
    else
        return t:Simleime_targetTermBuf
    endif
endf


function! g:Strip_space(input_string)
    return trim(a:input_string)
endfunction
function! g:Get_visual_selection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction


" TODO: test this mapping: you can run commands on a visual selection between two
" markers!
" nnoremap - :`a,`s

au BufRead,BufNewFile *.layout set filetype=sh
au BufRead,BufNewFile revise.* set filetype=sh
au BufRead,BufNewFile *.rc set filetype=sh
au BufRead,BufNewFile *.envrc set filetype=sh

augroup TerminalStuff
    au! 
    au TerminalOpen * if &buftype == 'terminal' | setlocal nonumber
augroup END


