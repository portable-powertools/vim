fun! g:DelLastSelectionNoDedent()
    normal gvc 
endf
fun! g:UsnipOfLastVisual()
    let l:selection = Get_visual_selection(1)
    let deletion = CaptureDeletion()
    call g:DelLastSelectionNoDedent()
    " echom deletion.whichPasteThen() . 'so isses'
    " if deletion.whichPasteThen() ==# 'p'
    "     echom 'gm'
    "     feedkeys("\<Esc>ll")
    " endif
    call g:UsnipAnonDedenting(l:selection, 'a')
endf

fun! g:UsnipAnonDedenting(snippet, ...)
    return call('g:UsnipAnon', [xolox#misc#str#dedent(a:snippet)] + a:000)
endf

" optional: options (i), description(""), trigger(see below)
fun! g:UsnipAnon(snippet, ...)
    let a:nmodeInitSeq = get(a:, 1, 'a')
    let a:options = get(a:, 2, 'i')
    let a:descr = get(a:, 3, '')
    let a:trigger = get(a:, 4, '__snippettrigger__')
    let g:snippetToExpand=a:snippet
    "TODOitclean: snippettoexpand is a global funnelling mess and won't scale
    call UltiSnips#CursorMoved()
    call feedkeys("\<Esc>".a:nmodeInitSeq.a:trigger."\<C-R>=UltiSnips#Anon(g:snippetToExpand, '".a:trigger."', '', '".a:options."')\<CR>")
    " normal a__snippettrigger__=UltiSnips#Anon(g:snippetToExpand, '__snippettrigger__')
endf


" sfdf$1d
" return sfdf$1d
" bla(sfdfusdd)

""" LEGACY STUFF: """

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  development mapping which takes a visual selection as snippet content  "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! -nargs=0 YankReselect normal vgb
command! -nargs=* US 


"""""""""""""""""""""""""""""""""""""""
"  demonstrative mapping and command  "
"""""""""""""""""""""""""""""""""""""""

" nmap <F12>zzz1 :call g:UsnipOfLastVisual()<CR>
" nmap <F12>zzz2 :call g:UsnipAnonDedenting('lambda ${1:x}: $2', 'a', 'i')<CR>
" command! USnipTest call g:UsnipAnonDedenting('test(${1:arg1}, foo($1, ${2:default=True}))', 'a', 'i')


" Honorary mention:
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  This is the original extraction mapping which stops at "extracted" placeholders where ultisnips now takes over  "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vmap <Leader>x "zxiextracted<Esc>^i<CR><ESC>k^aextracted = <ESC>"zp
"
"
"
" Graveyard: of debugging

" THese mappings used to be called before each refactoring. Long time agon
" since I saw them suckers, I hope! Better: never!
vmap <F5>00 <Esc>:let g:selAtRefactoring=CaptureDeletion()<CR>gv
" vmap <F5>00 <Esc><C-o><F5>00gv
nmap <F5>00 <Nop>

" nmap <F5>00 :sleep 2m<CR>:call UltisnipsExhaust()<CR>
":call g:UltisnipsExhaust()<CR>

" nmap <F5>__exhaust_snippet :if ! exists('b:usflag') <bar> call UltiSnips#ExpandSnippet() <bar> let b:usflag=1 <bar> else <bar> call UltiSnips#LeavingBuffer() <bar> endif <CR>
" imap <F5>__exhaust_snippet <C-o>mz<C-o>:echom 'usflag: '.exists('b:usflag') <bar> if ! exists('b:usflag') <bar> call UltiSnips#ExpandSnippet() <bar> let b:usflag=1 <bar> echom 'initialized refactoring in this buffer' <bar> else <bar>  echom 'calling US refresh method' <bar> call UltiSnips#LeavingBuffer() <bar> endif <CR><C-o>`z
" imap <F5>__exhaust_snippet <C-o>mz<C-o>:if ! exists('b:usflag') <bar> call UltiSnips#ExpandSnippet() <bar> let b:usflag=1 <bar> else <bar> exec g:_uspy "UltiSnips_Manager._current_snippet_is_done()" <bar> endif <CR><C-o>`z
" imap <F5>__exhaust_snippet <C-o>:if ! exists('b:usflag') <bar> call UltiSnips#ExpandSnippet() <bar> let b:usflag=1 <bar> else <bar> call UltiSnips#LeavingBuffer() <bar> endif <CR><C-o>
" imap <F5>__exhaust_snippet <C-o>mz<C-o>:call UltiSnips#LeavingBuffer()<CR><C-o>`z

augroup initrefactor
    au!
    " autocmd BufEnter * if &modifiable | call g:UltisnipsExhaust() | endif
augroup end

command! -nargs=* USE call g:UltisnipsExhaust()
command! -nargs=* ULB call UltiSnips#LeavingBuffer()
command! -nargs=* USE call g:_uspy "UltiSnips_Manager._current_snippet_is_done()
command! -nargs=* UES call g:UltiSnips#ExpandSnippet()
command! -nargs=* UCM call g:UltiSnips#CursorMoved()


fun! g:UltisnipsExhaust()
    
    call UltiSnips#CursorMoved()

    " " looks like this aint needed no more \o\o//o/
    " if ! exists('b:usflag')
    "    " call UltiSnips#ExpandSnippet()
    "     let b:usflag=1
    " else
    "     " call UltiSnips#CursorMoved()
    "     " " exec g:_uspy "UltiSnips_Manager._current_snippet_is_done()"
    "     " call UltiSnips#LeavingBuffer()
    " endif
endf

" hopefully not needed anymore with global V, v mappings
