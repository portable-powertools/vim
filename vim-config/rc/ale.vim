let g:ale_c_parse_compile_commands=0
let g:ale_c_parse_makefile=0

let g:ale_python_flake8_options='--max-line-length=1000 --ignore=E302,E303'
let g:ale_linters = {'python': ['flake8']}

" let g:ale_lint_on_text_changed = 'never'
" let g:ale_lint_on_enter = 0
nnoremap <Leader>aj :lnext<CR>
nnoremap <Leader>ak :lprevious<CR>
" nnoremap <Leader>a; :lopen<CR>

nnoremap <Leader>aaj :cnext<CR>
nnoremap <Leader>aak :cprevious<CR>
" nnoremap <Leader>aaa :copen<CR>

nnoremap <Leader>ar :ALEFindReferences<CR>
nnoremap <Leader>af :ALEFix<CR>
nnoremap <Leader>ad :ALEGoToDefinition<CR>
" nnoremap <Leader>ad :ALEGoToDefinition<CR>
" nnoremap <Leader>ad :ALEGoToDefinition<CR>

nmap <C-g><C-o> <Plug>window:quickfix:toggle

let g:lt_location_list_toggle_map = '<leader>a;'
let g:lt_quickfix_list_toggle_map = '<leader>aa;' 

let g:lt_height = 10

let g:ale_fixers = {
            \   'sh': [
            \       'shfmt'
            \   ]
            \} 
let g:ale_sh_shfmt_options = '-i 4'
