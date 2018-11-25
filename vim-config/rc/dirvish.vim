let g:dirvish_relative_paths=0

" execute shdo command window
map <Leader><Leader>x Z!

" TODO: filetype make dirvish map that directly reloads after toggle
command! -bar -nargs=0 DirvishRelTg let g:dirvish_relative_paths = !g:dirvish_relative_paths <bar> echo 'rel: '.g:dirvish_relative_paths


" How do I filter? ~
" Use |:global| to delete lines matching any filter: >
"     :g/foo/d
" To make this automatic, set |g:dirvish_mode|: >
"     let g:dirvish_mode = ':silent keeppatterns g/foo/d _'

" fun! g:AutoDirvish(cmdstub)
"     let l:identifier = substitute('a:cmdstub', '[^A-Za-z_0-9]', '_', 'g')
"     let l:command = substitute(a:cmdstub, '\V{}', fnameescape(expand('%:p:h')), "g")
"     execute 'augroup dirvishAu_'.identifier
"     autocmd!
"         " execute 'autocmd FileType dirvish execute ' . l:command
"         autocmd FileType dirvish execute l:command
"     augroup END
"     if &filetype == 'dirvish'
"         execute l:command
"     endif
" endf



fun! g:With_Module_dir(execfmt, name, ...)
    let l:flag = get(a:, 1, '-n')
    let l:retval = trim(system('ts_mod_dir ' . l:flag . ' ' . shellescape(a:name)))
    if v:shell_error == 0
        let l:extracted = printf(a:execfmt, l:retval)
        exec l:extracted
    else
        call xolox#misc#msg#warn('no module named ' . a:name . 'with flag ' . l:flag . 'found; not executing "' . a:execfmt . '".')
        return -1
    endif
endf


command! -nargs=+ Mcd call g:With_Module_dir('cd %s', <f-args>) 
command! -nargs=+ Med call g:With_Module_dir('e %s', <f-args>) 


augroup dirvish_config
  autocmd!

  " " Map `t` to open in new tab.
  " autocmd FileType dirvish
  "   \  nnoremap <silent><buffer> t :call dirvish#open('tabedit', 0)<CR>
  "   \ |xnoremap <silent><buffer> t :call dirvish#open('tabedit', 0)<CR>

  " " Map `gr` to reload.
  " autocmd FileType dirvish nnoremap <silent><buffer>
  "   \ gr :<C-U>Dirvish %<CR>

  " Map `gh` to hide dot-prefixed files.  Press `R` to "toggle" (reload).
    autocmd FileType dirvish nnoremap <silent><buffer>
    \   gh :silent keeppatterns g@\v/\.[^\/]+/?$@d _<cr>
    \|  nnoremap <silent><buffer> t :call dirvish#open('tabedit', 0)<CR>
    \|  lcd %
    \|  nmap <buffer> r R
    \|  nmap <buffer> <Leader>cd :cd %<CR>R:pwd<CR>
    \|  nmap <buffer> <Leader>ed :e %
    \|  nmap <buffer> <Leader>md :Mkdir %
    \|  nmap <buffer> <Leader>gcd :exec 'e '.getcwd(-1)<CR>
    \|  nmap <buffer> <Leader>~ :e $HOME/<CR>
    \|  nmap <buffer> <Leader>// :e /<CR>
    \|  nmap <buffer> <Leader><CR> :Silentviewer xdg-open <C-R><C-l><CR>
    \|  nmap <buffer> <C-g> :Grepper -noquickfix <C-g>d
    \|  setlocal tw=40

    autocmd BufEnter * if &filetype == 'dirvish' | lcd % | endif
    autocmd BufLeave * if &filetype == 'dirvish' | exe 'lcd '.getcwd(-1) | endif
augroup END



