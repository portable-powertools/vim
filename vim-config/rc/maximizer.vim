let g:maximizer_set_default_mapping = 0

nmap <silent><C-w><C-o> <C-w>o
vmap <silent><C-w><C-o> <C-w>o
imap <silent><C-w><C-o> <C-w>o
tmap <silent><C-w><C-o> <C-w>o

tnoremap <silent><C-w>o <C-w>N:MaximizerToggle!<CR>i
nnoremap <silent><C-w>o :MaximizerToggle!<CR>
vnoremap <silent><C-w>o :MaximizerToggle!<CR>gv
inoremap <silent><C-w>o <C-o>:MaximizerToggle!<CR>
tnoremap <silent><C-w>o <C-w>N:MaximizerToggle<CR>i
nnoremap <silent><C-w>O :MaximizerToggle<CR>
vnoremap <silent><C-w>O :MaximizerToggle<CR>gv
inoremap <silent><C-w>O <C-o>:MaximizerToggle<CR>
