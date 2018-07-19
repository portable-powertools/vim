set tw=0

" Verdin =====================
let g:Verdin#autocomplete = 0
let g:Verdin#cooperativemode = 1

"misc
" select to eol
nnoremap <Leader>ve v$h
nmap ,<Space> @

"dev shortcuts
"
nmap <F10>x :Chmod +x <bar> echo 'executed chmod +x'<CR>

"bash
" surround stuff with "$()" and "$"
vmap $( S(gvS"a$<ESC>f"
vmap $" S"a$<ESC>f"
imap <F10>fff () {<CR><CR>}<UP><TAB>
nmap <F10>fff $a<F10>fff<ESC>

"term
" toggle comment and send to term <bar> endif <bar> execute "normal \<F2>gm\<F2>gp" <bar> execute "normal \<F2>gm\<F2>gp" 
nmap <F2>gccall lh#buffer#find(g:Simleime_targetTermBuf)call lh#buffer#find(g:Simleime_targetTermBuf) gcc<F2>jgcc
vmap <F2>gc gcgv<F2>jgvgc
" shortcuts for sending
nnoremap <F2>1 :<C-w>:call g:Simleime_put_repeated("exit\n")<CR>
nnoremap <F2>2 :<C-w>:call g:Simleime_put_repeated("exec $BASH\n")<CR>
nnoremap <F2>3 :<C-w>:call g:Simleime_put_repeated("reloadbash\n")<CR>
nnoremap <F2>9y :Tp y<CR>
nnoremap <F2>9n :Tp n<CR>


