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

" indent repeat using visual mode
nmap <Leader>< gv<
nmap <Leader>> gv>

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

nmap <F10>__flash100 :silent! exec "normal zv"<CR>V:sleep 100m<CR><Esc>
nmap <F10>__flash200 :silent! exec "normal zv"<CR>V:sleep 200m<CR><Esc>
nmap <F10>__flash300 :silent! exec "normal zv"<CR>V:sleep 300m<CR><Esc>
nmap <F10>__flash400 :silent! exec "normal zv"<CR>V:sleep 400m<CR><Esc>
nmap <F10>__flash500 :silent! exec "normal zv"<CR>V:sleep 500m<CR><Esc>


" Python: new buffers and interaction through %paste with ipython terminal
    " next ones: this double mapping is somehow necessary........ its about producting an
    " illegal movement in the buffer space so that the <ESC> can be caught
nmap F10__pyImp <Leader>n:set ft=python<CR>iImp<Tab><ESC><CR><ESC>
nmap <Leader><Leader>N <F2>gM<C-w>p:Tp ip<CR><F10>__pyImp<Right><Esc>
nmap <Leader><Leader>n <Leader><Leader><Leader>nl<Esc>
nmap <F10>py :set ft=python<CR>
vmap <F2>ip <Esc>:let g:savevar=@+<CR>gv"+y:Tp %paste<CR>:sleep 200m<CR>:let @+=g:savevar<CR><C-o>
nmap <F2>ip vae<F2>ip
nmap <F2>id :Tp %debug<CR><F2>gg
tmap <F2>id <C-w>:Tp %debug<CR>
map <F2>Ip :Tp exit()<CR>:Tp ip<CR>
" Porcelain interaction:
    " yank last command from ipython
nmap <F2>yip <C-w>:Tp import sutil.system; import sutil.ipy; sutil.system.clip(sutil.ipy.lastHistCall())<CR>
tmap <F2>yip <C-w>:Tp import sutil.system; import sutil.ipy; sutil.system.clip(sutil.ipy.lastHistCall())<CR>
    " paste last command from ipython into buffer by sending it a sutil command
nmap <F2>pip <F2>yip:sleep 230m<CR>p




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
nnoremap <Leader>ve v$h
nmap <F12> @
vmap <F12> @
" tab navigatrion vfrom terminal
tmap <C-PageUp> <C-w>:tabp<CR>
tmap <C-PageDown> <C-w>:tabn<CR>

set textwidth=0
set timeoutlen=2000

" half as fast PgUp/down events
nnoremap <PageUp> <C-u>
nnoremap <PageDown> <C-d>

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
nnoremap V m`m'V
nnoremap v m`m'v
nnoremap gv m`gv

nnoremap <Leader>: :<C-u>'<,'>
" schlepp imitations for single lines
" nnoremap J :.t.<CR>
vmap J :<C-u>'<,'>t'><CR>
vmap K :<C-u>'<,'>t'<-1<CR>

"   mark -1 for appending instead of prepending with m,t,etc
cnoremap ''' '-1<Left><Left>
cnoremap ``` `-1<Left><Left>
"   aliases for backtick
nnoremap "" `
nnoremap """ ``
vnoremap "" `
vnoremap """ ``

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



