set tw=0
set clipboard=unnamedplus
set timeoutlen=2000


tmap <C-PageUp> <C-w>:tabp<CR>
tmap <C-PageDown> <C-w>:tabn<CR>


" Verdin =====================
let g:Verdin#autocomplete = 0
let g:Verdin#cooperativemode = 1

"misc
command! -nargs=0 Q execute ':qa!'
" select to eol
nnoremap <Leader>ve v$h
nmap <F12> @
vmap <F12> @

"dev shortcuts
"
nmap <F10>cx :Chmod +x <bar> echo 'executed chmod +x'<CR>

"bash
" surround stuff with "$()" and "$"
vmap $( S(gvS"a$<ESC>f"
vmap $" S"a$<ESC>f"
imap <F10>fff () {<CR><CR>}<UP><TAB>
nmap <F10>fff $a<F10>fff<ESC>


"term
" toggle comment and send to term <bar> endif <bar> execute "normal \<F2>gm\<F2>gp" <bar> execute "normal \<F2>gm\<F2>gp" 
" SEEMS to be horribly mangled an may not work. test?
nmap <F2>gccall lh#buffer#find(g:Simleime_targetTermBuf)call lh#buffer#find(g:Simleime_targetTermBuf) gcc<F2>jgcc
vmap <F2>gc gcgv<F2>jgvgc

" shortcuts for sending
nnoremap <F2>1 :<C-w>:call g:Simleime_put_repeated("exit\n")<CR>
nnoremap <F2>2 :<C-w>:call g:Simleime_put_repeated("exec $BASH\n")<CR>
nnoremap <F2>3 :<C-w>:call g:Simleime_put_repeated("reloadbash\n")<CR>
nnoremap <F2>9y :Tp y<CR>
nnoremap <F2>9n :Tp n<CR>

" For keyboards not as awesome as mine :P
nmap <Space>1 <F1>
nmap <Space>2 <F2>
nmap <Space>3 <F3>
nmap <Space>4 <F4>
nmap <Space>5 <F5>
nmap <Space>6 <F6>
nmap <Space>7 <F7>
nmap <Space>8 <F8>
nmap <Space>9 <F9>
nmap <Space>10 <F10>
