
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                    restructuring my mappings day                    "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap >. <Nop>
nmap <. <Nop>
nmap > <Nop>
nmap < <Nop>
xmap > <Nop>
xmap < <Nop>
nnoremap <C-t> >
nnoremap <Leader><C-t> <
nnoremap ;<C-t> =
vnoremap ;<C-t> =
vnoremap <C-t> >gv
vnoremap <Leader><C-t> <gv


omap . :<C-u>normal V<CR>
omap <<< :<C-u>normal '<k<CR>
omap >>> :<C-u>normal '>j<CR>

map >> <Plug>(easmotion-next)
map << <Plug>(easymotion-prev)
map ;<Right> <Plug>(easymotion-next)
map ;<Left> <Plug>(easymotion-prev)
noremap <Right> ;
noremap <Left> ,

map <Leader>v gv
map <Leader><Leader>v vgb


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                         Also pretty recent:                         "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""
"  surround in all modes  "
"""""""""""""""""""""""""""

imap <C-d>( <C-d>)
imap <C-d>[ <C-d>]
imap <C-d>{ <C-d>}
imap <C-d><Space> <C-d>  <Space><Space><Left>
imap <C-d><C-d> <C-d>'

cnoremap <C-d>' ''<Left>
cnoremap <C-d>" ""<Left>
cnoremap <C-d>) ()<Left>
cnoremap <C-d>] []<Left>
cnoremap <C-d>} {}<Left>
cnoremap <C-d>> <lt>><Left>
tnoremap <C-d>' ''<Left>
tnoremap <C-d>" ""<Left>
tnoremap <C-d>) ()<Left>
tnoremap <C-d>] []<Left>
tnoremap <C-d>} {}<Left>
tnoremap <C-d>f "$()"<Left><Left>
tnoremap <C-d>v "$"<Left>
tnoremap <C-d><C-d> <C-d>



" ending the auto-deindent nightmare with o and O: these keep the space when used (i after the fact)
imap <F10><Tab> <Space><BS>
imap <F10>o <C-o>o<Space><BS>
imap <F10>O <C-o>O<Space><BS>
imap <F10>p <F10><Tab><C-o>:Regtrim<CR><C-o>p
nmap go o<F10><Tab><esc>
nmap gO O<F10><Tab><esc>
nmap gao o<F10><Tab><esc>a
nmap gaO O<F10><Tab><esc>a


" Normal mark behavior for macros etc
nmap ,q<C-t> <Plug>(TaggedSearchPatternList)
" equivalently...
nmap <Leader>q; q:

" Umgewoehnung
nmap ,fb <Nop>
nmap ,fe <Nop>
nmap ,fg <Nop>
nmap ,fl <Nop>
nmap ,fL <Nop>
nmap ,fw <Nop>
nmap ,ft <Nop>
nmap ,fT <Nop>
nmap ,f/ <Nop>
nmap ,f: <Nop>
nmap ,fH <Nop>
nmap ,fc <Nop>
nmap ,fm <Nop>
nmap ,fs <Nop>
nmap ,fh <Nop>
nmap ,fy <Nop>


" in visual, end should not select the END
xmap <End> $h

" surround
nmap <C-d> ys

"scratch
let g:scratch_filetype = 'python'

" clip current path
command! -nargs=0 Clippath let @+ = expand('%:p')


" Plugin: braceless for python textobjects basically. Maybe for python
" folding? TODO: Simpylfold vs braceless
autocmd FileType python BracelessEnable +indent

" Tagbar navigation
nmap <Leader><Space>tj :TagbarOpen fjc<CR>j<CR>
nmap <Leader><Space>tk :TagbarOpen fjc<CR>k<CR>
nmap <Leader><Space>tt :TagbarOpen fj<CR>

nmap ,i `^a

"Plugin: Openbrowser
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
" Open URI under cursor.

" Plugin: Tagged searches
" TODO: basic scripts for backing up and cleaning up duplicates
let g:TaggedSearchPattern_HighlightTags = 1
" highlight link TaggedSearchTag Search
" highlight TaggedSearchNeutral ctermfg=Black guifg=White

" TODO-idea let fzf Ag command use the default Grepper
" TODO-idea tag and save regexes

" Plugin: Vimple
"

" Toggle hlsearch
nnoremap <silent><expr> <F11>h (&hls && v:hlsearch ? ':nohls' : ':set hls')."\n"

""""""""""""""""""""""""""""""""
"  TO BE PROVEN USEFUL STILL:  "
""""""""""""""""""""""""""""""""

" Searching for config options in plugin help files
let g:plugtags = '\m\*\([:!-_]\|\w\)*\*'
let g:hashbox = '^#.*#$'
let g:quotebox = '^".*"$'
map! <F3><F3>help <C-r>=g:plugtags<CR>
map! <F3><F3>boxq <C-r>=g:quotebox<CR>
map! <F3><F3>boxx <C-r>=g:hashbox<CR>

" maps for previous buffer, in both term and normal buffers
nmap <C-w>P :b#<CR>
tmap <C-w>P <C-w>:b#<CR>

" expands a relative file name under the cursor to the absolute one in the current file's directory
cmap <C-R><C-R><C-F> <C-r>=expand('%:p:h')<CR>/<C-r><C-f>

" trim Register
command! -register Regtrim :call setreg(g:Expandreg(<q-reg>), trim(getreg(g:Expandreg(<q-reg>))))
nmap <silent> g" :Regtrim<CR>




""""""""""""""""""""""""""""""""""""""""""""""""
"  FILETYPE SPECIFIC AKA TEMPORARY HACKS:      "
""""""""""""""""""""""""""""""""""""""""""""""""
" TODO: filetype

" Bash: surround stuff with "$()" and "$" 
vmap $( S(gvS"a$<ESC>f"
vmap $" S"a$<ESC>f"
imap <F10>fff () {<CR><CR>}<UP><TAB>
nmap <F10>fff $a<F10>fff<ESC>


" Python: send fun invocation without arguments to terminal
" this one with default namespace qualifier e.<funname> for my workflow in ipython
map <F2>pf :TP e.<CR>mz[pfw<F2>w:Tp ()<CR>`z


nmap <F10>__flash100 :silent! call g:FlashLine(line('.'), 1, 100)<CR>
nmap <F10>__flash200 :silent! call g:FlashLine(line('.'), 1, 200)<CR>
nmap <F10>__flash300 :silent! call g:FlashLine(line('.'), 1, 300)<CR>
nmap <F10>__flash400 :silent! call g:FlashLine(line('.'), 1, 400)<CR>
nmap <F10>__flash500 :silent! call g:FlashLine(line('.'), 1, 500)<CR>
nmap <F10>__flash999 :silent! call g:FlashLine(line('.'), 1, 999)<CR>


" Python: new buffers and interaction through %paste with ipython terminal
    " next ones: this double mapping is somehow necessary........ its about producting an
    " illegal movement in the buffer space so that the <ESC> can be caught
nmap <F10>__pyImp <Leader>n:set ft=python<CR>iImp<Tab><ESC><CR><ESC>
nmap <Leader><Leader>N <F2>gM<C-w>p:Tp ip<CR><F10>__pyImp<Right><Esc>
nmap <Leader><Leader>n <Leader><Leader><Leader>nl<Esc>
vmap <F2>ip <Esc>:let g:savevar=@+<CR>gv"+y:Tp %paste<CR>:sleep 200m<CR>:let @+=g:savevar<CR><C-o>
nmap <F2>ip vae<F2>ip
nmap <F2>id :Tp %debug<CR><F2>gg
tmap <F2>id <C-w>:Tp %debug<CR>
map <F2>Ip :Tp exit()<CR>:Tp ip<CR>
" Porcelain interaction:
    " yank last command from ipython
nmap <F2>yip <C-w>:<C-u><C-R>='Tp import sutil.system; import sutil.ipy; sutil.system.clip(sutil.ipy.lastHistCalls('.v:count1.'))'<CR><CR>
tmap <F2>yip <C-w>:<C-u><C-R>='Tp import sutil.system; import sutil.ipy; sutil.system.clip(sutil.ipy.lastHistCalls('.v:count1.'))'<CR><CR>
" paste last command from ipython into buffer by sending it a sutil command
nmap <F2>pip <F2>yip:sleep 230m<CR>pVG
tmap <F2>pip <C-w>:Scratch<CR>1<F2>pipVGgcG<F2>gg

"""""""""""""""""""""
"  PLUGIN SPECIFIC: "
"""""""""""""""""""""

" Verdin =====================
let g:Verdin#autocomplete = 0
let g:Verdin#cooperativemode = 1

" Replace operator plugin
map <Leader>rp  <Plug>(operator-replace)
vmap <silent> <Leader>rp  <Esc>:let g:savestripped=getreg(v:register)<CR>:call g:Stripreg(v:register)<CR>gvdP:call setreg(v:register, g:savestripped)<CR>

" Plugin: Tagbar
let g:tagbar_sort = 0
let g:tagbar_compact = 1

nnoremap <F10>tf :TagbarTogglePause<CR>
nnoremap <F10>tj :TagbarOpen fj<CR>
nnoremap <F10>tJ :TagbarOpen fjc<CR>
nnoremap <F10>t; :TagbarToggle<CR>

" Plugin: textobj_arg
let g:vim_textobj_parameter_mapping = 'a'

" Plugin: surround, basic
imap <C-d> <C-g>s
vmap <C-d> S

" Plugin: buffersaurus
let g:buffersaurus_autodismiss_on_select = 0
let g:buffersaurus_set_search_register = 0
let g:buffersaurus_filetype_term_map = {"test": 'function'}
let g:buffersaurus_element_term_map = {"test" : "attr\.s"}
let g:buffersaurus_context_size = [2,2]
" e.g. "PyDef"       : '^\s*def\s\+[A-Za-z_]\i\+(.*'



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  BASIC TRIED AND TRUE CANDIDATES FOR BASICMAPS OR THE LIKE:  "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! -nargs=0 Q execute ':qa!'
" select to eol
nmap ;q @
nmap ;;q @@
vmap ;q @
vmap ;;q @@
" tab navigatrion vfrom terminal
tmap <C-PageUp> <C-w>:tabp<CR>
tmap <C-PageDown> <C-w>:tabn<CR>

set textwidth=0
set timeoutlen=2000


" Home key is whitespace sensitive with this
vmap <Home> ^
nmap <Home> ^
omap <Home> ^
imap <Home> <C-o>^

" Silentviewer: Silently executing commands like an image viewer with 
command! -nargs=* Silentviewer execute ':silent !'.<q-args>.' >/dev/null 2>&1' | execute ':redraw!'
command! -nargs=* Xdgo execute ':silent ! xdg-open '.<q-args>.' >/dev/null 2>&1' | execute ':redraw!'
"   open URL in google chrome
"   this one directly takes the WORD under the cursor
nmap <F10>chR :Silentviewer /opt/google/chrome/chrome <C-r><C-a>
nmap <F10>chr :Silentviewer /opt/google/chrome/chrome 

" Move_stuff:
" Jumplist: jumplist entries and opening excmdline on visual
" Visual: let visual selection leave jumplist trace
" nnoremap V m`m'V
" nnoremap v m`m'v
" nnoremap gv m`gv

nnoremap <: :<C-u>'<,'>
" schlepp imitations for single lines
" nnoremap J :.t.<CR>
vmap J :<C-u>'<,'>t'><CR>V
vmap K :<C-u>'<,'>t'<-1<CR>V


" Vimrc: drop new stuff from anywhere
command! -nargs=0 Dropvrc call g:With_Module_dir('edit %s/vim-config/rc/dropnewstuffhere.vim', 'vim')



""""""""""""""""""""""""""
"  GRAVEYARD CANDIDATES: "
""""""""""""""""""""""""""
" " For keyboards not as awesome as mine :P
" nmap <Space>1 <F1>
" nmap <Space>2 <F2>
" nmap <Space>3 <F3>
" nmap <Space>4 <F4>
" nmap <Space>5 <F5>
" nmap <Space>6 <F6>
" nmap <Space>7 <F7>
" nmap <Space>8 <F8>
" nmap <Space>9 <F9>
" nmap <Space>10 <F10>



