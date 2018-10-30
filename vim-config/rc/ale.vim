

let g:ale_c_parse_compile_commands=0
let g:ale_c_parse_makefile=0

fun! g:MakeFlake8Options()
    let l:opts=''
    let l:list=[]
    let l:i = 0
    while l:i < len(g:flake8flags)
        let l:list = add( l:list, g:flake8flags[ l:i ] )
        let l:i += 1
    endwhile

    let l:errlist=[]
    let l:i = 0
    while l:i < len(g:flake8errors)
        let l:errlist = add( l:errlist, g:flake8errors[ l:i ] )
        let l:i += 1
    endwhile
    let l:errflag='--ignore=' . join(l:errlist, ',')

    call add(l:list, l:errflag)
    
    let g:ale_python_flake8_options = join(l:list, ' ')
endf

command! -nargs=1 F8flagadd call let g:flake8errors = add(g:flake8errors, <f-args>) | call g:MakeFlake8Options() | ALELint
command! -nargs=1 F8add call add(g:flake8errors, <f-args>) | call g:MakeFlake8Options() |  ALELint
let g:flake8errors=[]
let g:flake8flags=['--max-line-length=1000']

let g:flake8errors = add(g:flake8errors, 'E302')
let g:flake8errors = add(g:flake8errors, 'E303')
let g:flake8errors = add(g:flake8errors, 'E304')
let g:flake8errors = add(g:flake8errors, 'E305')
let g:flake8errors = add(g:flake8errors, 'E265')
let g:flake8errors = add(g:flake8errors, 'E266')

call add(g:flake8errors, 'E201') " whitespace around function arg
call add(g:flake8errors, 'E202') " whitespace around function arg
call add(g:flake8errors, 'E111')
call add(g:flake8errors, 'F403')

call g:MakeFlake8Options()

nnoremap <Leader>alint :ALELint<CR>
nmap <F11>ale <plug>(ale_toggle)

" let g:ale_python_flake8_options='--max-line-length=1000 --ignore=E302,E303,E304,E305,E265,E266'
"302,303: number of blank lines allowed (really?)
"265, 266: number of "#" allowed for comments (ok, matter of taste I guess)

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
