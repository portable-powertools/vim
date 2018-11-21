"""""""""""""""""""""""""""""""
"  User interface maps: F5-5  "

let g:refSpeed = 80
command! -count=4 -nargs=0 RejoinAndDel let tbc=g:VarCatch(line("."), <count>, col(".")) | if ! empty(tbc) | let tbcBest = tbc[0] | call g:Client_RejoinAndDel(tbcBest, g:refSpeed) | else | call xolox#misc#msg#warn('no joinable variable found') | endif
command! -count=4 -nargs=0 Rejoin let tbc=g:VarCatch(line("."), <count>, col(".")) | if ! empty(tbc) | let tbcBest = tbc[0] | call g:Client_Rejoin(tbcBest, g:refSpeed) | else | call xolox#misc#msg#warn('no joinable variable found') | endif
command! -count=4 -nargs=0 ShowRejoin let tbc=g:VarCatch(line("."), <count>, col(".")) | if ! empty(tbc) | call g:Client_ShowRejoinable(tbc, g:refSpeed) | else | call xolox#misc#msg#warn('no joinable variable found') | endif
command! -count=4 -nargs=0 GoNextCatchvar let tbc=g:VarCatch(line("."), <count>, col(".")-1) | if ! empty(tbc) | call g:Client_GoToCatchvar(tbc[0]) | else | call xolox#misc#msg#warn('no joinable variable found') | endif
command! -count=4 -nargs=0 GoPrevCatchvar let tbc=g:VarCatch(line("."), <count>, col(".")-1) | if ! empty(tbc) | call g:Client_GoToCatchvar(tbc[len(tbc) > 1 ? -2 : 0]) | else | call xolox#misc#msg#warn('no joinable variable found') | endif

nmap <F5>xs :call g:TryScope(g:PLScopes, 0, 0)<CR>
map <F5>xC :RejoinAndDel<CR>
map <F5>xc :Rejoin<CR>
map <F5>x<Space>c :ShowRejoin<CR>
map <F5>x<Left> :GoNextCatchvar<CR>
map <F5>x<Right> :GoNextCatchvar<CR>
imap <F5><F5> <Esc>:call g:TryScope(g:PLScopes, 1, 0)<CR>
" map <F5>or :let g:testscope=g:PLRexScope(getline('.'),g:PL_assignmentscope) <bar> if ! empty(g:testscope) <bar> call g:SetVisualScope(line('.'), g:testscope) <bar> exec "normal gv" <bar> else <bar> endif <CR>


vmap <Leader><Space><Space> <F5>x
nmap <Leader><Space><Space> <F5>x

" Scopes: patterns that mark with \zs and \ze where the most interesting stuff
" on a (python) line is (probably)

let g:PL_assignmentscope = '\v^\s*(\h%(\i|[\[\]''"])*)\s*\=\s*\zs(\S[^#]{-})\ze\s*(#.*$)?$'
let g:PLScopes= [ g:PL_assignmentscope ] + g:PLMakeKWScopes( 'return', 'if', 'for \v\i+ in', 'while', 'with', '')


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                 =====  The snippets =====                           "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""
"  Extraction into variable "
""""""""""""""""
vmap <F5>xv <F5>00"zxi$1$0<Esc>^i<CR><ESC>k^a${1:extracted} = <ESC>"zpa${3:  # type: ${2:object}}<Esc>Vj<Esc>:call g:UsnipOfLastVisual()<CR>
vmap <F5>xxv <F5>00"zxi$1$0<Esc>^i<CR><ESC>k^a${1:extracted} = <ESC>"zpVj<Esc>:call g:UsnipOfLastVisual()<CR>
" vmap <F5>xlv <F5>00"
vmap <F5>xlv <F5>00"zx<F5>II$3$0<Esc>^i<CR><ESC>k^alet ${3:${2:}${1:extracted}} = <ESC>"zpVj<Esc>:call g:UsnipOfLastVisualRefactoring()<CR>
nmap <F5>xv vi)<F5>xv
nmap <F5>xxv vi)<F5>xxv
nmap <F5>xlv vi)<F5>xlv

""""""""""""""""""""""""""""""
"  Extraction into called function "
""""""""""""""""""""""""""""""

vmap <F5>xV <F5>00"zx<F5>II$1($2)$0<Esc>^i<CR><ESC>k^adef ${1:extracted}(${2:x}):<Esc>oreturn <ESC>"zpa$3<Esc>kVjj<Esc>:call g:UsnipOfLastVisual()<CR>
" version when cursor is in braces scope
nmap <F5>xV via<F5>xV


""""""""""""""""""""""""""""""
"  Extraction of a lambda function into named. cursor needs just be after that lambda. "
""""""""""""""""""""""""""""""
" nmap <Leader>vL mz:call search('lambda', 'cb')<CR>v`z
vmap <F5>xL <F5>00"zx<F5>II$1$0<Esc>^i<CR><ESC>k^adef ${1:extracted}(<Esc>mza):<Esc>o<Space><BS><ESC>"zpa$3<Esc>:call search('lambda', 'b')<CR>dwmx:call search('\m\s*:')<CR>mcdf:ireturn<Esc>`chv`x"zx`z"zpVjj<Esc>:call g:UsnipOfLastVisual()<CR>
nmap <F5>xL <Leader>vL<F5>xL

" lbi: move right, then back guarantees beginning of the var


""""""""""""""""""""""""""""""
"  Extraction of incomplete lambda def of one arg into named function with one variable. think, extracting f(x+2) into a lambda "
"  Variable is marked by cursor "
""""""""""""""""""""""""""""""
" THis one goes back to the cursor pos before visual selection to get the
" variable
" vmap <F5>xf <F5>00<Esc><C-o>lbi${2:<Esc>ea}<Esc>`<v`>5l"zx<F5>II$1$0<Esc>^i<CR><ESC>k^adef ${1:extracted}($2):<Esc>oreturn <ESC>"zpa$3<Esc>kVjj<Esc>:call g:UsnipOfLastVisual()<CR>
"marked with x version
vmap <F5>xxf <F5>00<Esc>`xlbi${2:<Esc>ea}<Esc>`<v`>5l"zx<F5>II$1$0<Esc>^i<CR><ESC>k^adef ${1:extracted}($2):<Esc>oreturn <ESC>"zpa$3<Esc>kVjj<Esc>:call g:UsnipOfLastVisual()<CR>
"marked with x and in braces scope normal version
nmap <F5>xxf <F5>00mz`xlbi${2:<Esc>ea}<Esc>`zvia"zx<F5>II$1$0<Esc>^i<CR><ESC>k^adef ${1:extracted}($2):<Esc>oreturn <ESC>"zpa$3<Esc>kVjj<Esc>:call g:UsnipOfLastVisual()<CR>
"cursor on arg/x and in braces scope normal version
nmap <F5>xf mx<F5>xxf

" lbi: move right, then back guarantees beginning of the var


""""""""""""""""""""""""""""""
"  Extraction into named function of incomplete incomplete lambda def with arbitrary arglist
""""""""""""""""""""""""""""""

vmap <F5>xF <F5>00"zxi$1$0<Esc>^i<CR><ESC>k^adef ${1:extracted}(${2:x}):<Esc>oreturn <ESC>"zpa$3<Esc>kVjj<Esc>:call g:UsnipOfLastVisual()<CR>
" normal version when cursor is in braces scope
nmap <F5>xF via<F5>xF

