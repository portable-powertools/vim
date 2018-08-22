let g:localvimrc_event = ['BufWinEnter', 'FileType', 'VimEnter', 'TabEnter', 'TabNew']
let g:dirvish_relative_paths=1
nnoremap <silent> <F11>d :let g:dirvish_relative_paths = !g:dirvish_relative_paths <bar> echo 'rel: '.g:dirvish_relative_paths<CR>


" How do I filter? ~
" Use |:global| to delete lines matching any filter: >
"     :g/foo/d
" To make this automatic, set |g:dirvish_mode|: >
"     let g:dirvish_mode = ':silent keeppatterns g/foo/d _'


" let t:Simleime_termcommand = 'linitbash here '.shellescape($mod_catkin_root)

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
    \|  xnoremap <silent><buffer> t :call dirvish#open('tabedit', 0)<CR>
    \|  nmap <buffer> r R
    \|  nmap <buffer> <Leader>cd :cd %<CR>R:pwd<CR>
    \|  nmap <buffer> <Leader>ed :e %
    \|  nmap <buffer> <Leader>md :Mkdir %
    \|  nmap <buffer> <Leader>gcd :exec 'e '.getcwd(-1)<CR>

    autocmd BufEnter * if &filetype == 'dirvish' | lcd % | endif
    autocmd BufLeave * if &filetype == 'dirvish' | exe 'lcd '.getcwd(-1) | endif
augroup END
