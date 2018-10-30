
"""""""""""""""""""""""""""""""""""""
"  necessary evils so its reliable  "
"""""""""""""""""""""""""""""""""""""
" reselection but with jumppoint set
nnoremap gv m`gv

vmap <F5>00 <F5>__exhaust_snippet
nmap <F5>00 <F5>__exhaust_snippet
imap <F5>00 <F5>__exhaust_snippet

vmap <F5>__exhaust_snippet <Esc><C-o><F5>__exhaust_snippetgv
nmap <F5>__exhaust_snippet i<F5>__exhaust_snippet<Esc>`z
" imap <F5>__exhaust_snippet <C-o>mz<C-o>:echom 'usflag: '.exists('b:usflag') <bar> if ! exists('b:usflag') <bar> call UltiSnips#ExpandSnippet() <bar> let b:usflag=1 <bar> echom 'initialized refactoring in this buffer' <bar> else <bar>  echom 'calling US refresh method' <bar> call UltiSnips#LeavingBuffer() <bar> endif <CR><C-o>`z
" imap <F5>__exhaust_snippet <C-o>mz<C-o>:if ! exists('b:usflag') <bar> call UltiSnips#ExpandSnippet() <bar> let b:usflag=1 <bar> else <bar> exec g:_uspy "UltiSnips_Manager._current_snippet_is_done()" <bar> endif <CR><C-o>`z
imap <F5>__exhaust_snippet <C-o>mz<C-o>:if ! exists('b:usflag') <bar> call UltiSnips#ExpandSnippet() <bar> let b:usflag=1 <bar> else <bar> call UltiSnips#LeavingBuffer() <bar> endif <CR><C-o>`z
" imap <F5>__exhaust_snippet <C-o>mz<C-o>:call UltiSnips#LeavingBuffer()<CR><C-o>`z

augroup initrefactor
    au!
    autocmd BufEnter * if &modifiable | silent! exec "norm \<F5>__exhaust_snippet" | endif
augroup end

"""""""""""""""""""""""""""""""
"  User interface maps: F5-5  "

" <F5>5 is <F5>x == the extraction 'mapspace'
vmap <F5>5 <F5>x
map <F5>5 <F5>x
imap <F5>5 <Esc><F5>x
vmap <Leader><Space><Space> <F5>x
nmap <Leader><Space><Space> <F5>x

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                 =====  The snippets =====                           "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"  reintegrating a variable
" map <F4>xj ^:call search('=')<CR>wmz:call search('\v\S\s*(#.*)?$')<CR>v`z"zx^"xxiwdd:s/\V<C-r>x/<C-r>z/<CR>:call search('\V<C-r>z', 'ce')
" command! -range -nargs=0 Rejoin exe "norm ^" | call search('\v\s*\w+\s*\=', 'ce') | exe "norm wmz" | call search('\v\S\s*(#.*)?$') | exe 'norm v`z"zx^"xxiwdd:s/V'.getreg('x').'/'.getreg('z')."/\<CR>" | call search('\V'.getreg('z'), 'ce')
" command! -range -nargs=-1 Rejoin exe "norm ^" | call search('\v\s*\w+\s*\=', 'ce') | exe "norm wmz" | call search('\v\S\s*(#.*)?$') | echom 'norm v`z"zx^"xxiwdd:s/V'.getreg('x').'/'.getreg('z')."/"

" command! -range -nargs=0 Rejoin exe "norm ^" | call search('\v\s*\w+\s*\=', 'ce') | exe "norm wmz" | call search('\v\S\s*(#.*)?$') | exec 'norm v`z"zy^"xyiw:<line1>,<line2>s/\V'.getreg('x').'/'.getreg('z')."/\<CR>"
" command! -range -nargs=1 VarRejoin call search('\V'.<q-args>, 'b') | echom 'hi! go'





""""""""""""""""
"  Extraction into variable "
""""""""""""""""
vmap <F5>xv <F5>00"zxi$1$0<Esc>^i<CR><ESC>k^a${1:extracted} = <ESC>"zpa${3:  # type: ${2:object}}<Esc>Vj<Esc>:call g:UsnipOfLastVisual()<CR>
nmap <F5>xv vi)<F5>xv


""""""""""""""""""""""""""""""
"  Extraction into called function "
""""""""""""""""""""""""""""""

vmap <F5>xV <F5>00"zxi$1($2)$0<Esc>^i<CR><ESC>k^adef ${1:extracted}(${2:x}):<Esc>oreturn <ESC>"zpa$3<Esc>kVjj<Esc>:call g:UsnipOfLastVisual()<CR>
" version when cursor is in braces scope
nmap <F5>xV via<F5>xf


""""""""""""""""""""""""""""""
"  Extraction of a lambda function into named. cursor needs just be after that lambda. "
""""""""""""""""""""""""""""""
nmap <Leader>vl :call search('lambda', 'cb')<CR>via
vmap <F5>xl <F5>00"zxi$1$0<Esc>^i<CR><ESC>k^adef ${1:extracted}(<Esc>mza):<Esc>o<Space><BS><ESC>"zpa$3<Esc>:call search('lambda', 'b')<CR>dwmx:call search('\m\s*:')<CR>mcdf:ireturn<Esc>`chv`x"zx`z"zpVjj<Esc>:call g:UsnipOfLastVisual()<CR>
nmap <F5>xl <Leader>vl<F5>xl

" x, zreturn a(b ()c())

" lbi: move right, then back guarantees beginning of the var
" C-o after exiting visual mode goes to cursor pos before it was selected. gv itself is mapped in this file so it sets a jump mark - so the user may select without directly hitting the variable, then reposition, gv, and then this mapping


""""""""""""""""""""""""""""""
"  Extraction of incomplete lambda def of one arg into named function with one variable. think, extracting f(x+2) into a lambda "
"  Variable is marked by cursor "
""""""""""""""""""""""""""""""
vmap <F5>xf <F5>00<Esc><C-o>lbi${2:<Esc>ea}<Esc>`<v`>5l"zxi$1$0<Esc>^i<CR><ESC>k^adef ${1:extracted}($2):<Esc>oreturn <ESC>"zpa$3<Esc>kVjj<Esc>:call g:UsnipOfLastVisual()<CR>
"marked with x version
vmap <F5>xxf <F5>00<Esc>`xlbi${2:<Esc>ea}<Esc>`<v`>5l"zxi$1$0<Esc>^i<CR><ESC>k^adef ${1:extracted}($2):<Esc>oreturn <ESC>"zpa$3<Esc>kVjj<Esc>:call g:UsnipOfLastVisual()<CR>
"marked with x and in braces scope normal version
nmap <F5>xxf <F5>00mz`xlbi${2:<Esc>ea}<Esc>`zvia"zxi$1$0<Esc>^i<CR><ESC>k^adef ${1:extracted}($2):<Esc>oreturn <ESC>"zpa$3<Esc>kVjj<Esc>:call g:UsnipOfLastVisual()<CR>
"cursor on arg/x and in braces scope normal version
nmap <F5>xf mx<F5>xxf

" lbi: move right, then back guarantees beginning of the var
" C-o after exiting visual mode goes to cursor pos before it was selected. gv itself is mapped in this file so it sets a jump mark - so the user may select without directly hitting the variable, then reposition, gv, and then this mapping


""""""""""""""""""""""""""""""
"  Extraction into named function of incomplete incomplete lambda def with arbitrary arglist
""""""""""""""""""""""""""""""

vmap <F5>xF <F5>00"zxi$1$0<Esc>^i<CR><ESC>k^adef ${1:extracted}(${2:x}):<Esc>oreturn <ESC>"zpa$3<Esc>kVjj<Esc>:call g:UsnipOfLastVisual()<CR>
" normal version when cursor is in braces scope
nmap <F5>xF via<F5>xF

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  development mapping which takes a visual selection as snippet content  "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

vmap ,us "zxi_adhoc_<C-R>=UltiSnips#Anon(getreg('z'), '_adhoc_')<CR>


"""""""""""""""""""""""""""""""""""""""
"  demonstrative mapping and command  "
"""""""""""""""""""""""""""""""""""""""

nmap <F12>zzz1 :call g:UsnipOfLastVisual()<CR>
nmap <F12>zzz2 :call g:UsnipAnonDedenting('lambda ${1:x}: $2')<CR>
command! USnipTest call g:UsnipAnonDedenting('test(${1:arg1}, foo($1, ${2:default=True}))')



"""""""""""""""""""
"  support funcs  "
"""""""""""""""""""

fun! g:DelLastSelectionNoDedent()
    normal gvc 
endf
fun! g:UsnipOfLastVisual()
    let l:selection = Get_visual_selection()
    call g:DelLastSelectionNoDedent()
    call g:UsnipAnonDedenting(l:selection)
endf

fun! g:UsnipAnonDedenting(snippet)
    let g:snippetToExpand=a:snippet
    normal a__snippettrigger__=UltiSnips#Anon(xolox#misc#str#dedent(g:snippetToExpand), '__snippettrigger__')
endf


function! RightAlignVisual() range
    let lim = [virtcol("'<"), virtcol("'>")]
    let [l, r] = [min(lim), max(lim)]
    exe "'<,'>" 's/\%'.l.'v.*\%<'.(r+1).'v./\=StrPadLeft(submatch(0),r-l+1)'
endfunction
function! StrPadLeft(s, w)
endfunction


" Honorary mention:
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  This is the original extraction mapping which stops at "extracted" placeholders where ultisnips now takes over  "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vmap <Leader>x "zxiextracted<Esc>^i<CR><ESC>k^aextracted = <ESC>"zp
"
"
"
"
"
"
"
"
"
"
"
"
"
"
"
"

