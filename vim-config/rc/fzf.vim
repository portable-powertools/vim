
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fe :Files<CR>
nnoremap <leader>fg :Ag<CR>
nnoremap <leader>fcol :Colors<CR>
nnoremap <leader>fl :BLines<CR>
nnoremap <leader>fL :Lines<CR>
nnoremap <leader>fw :Windows<CR>
nnoremap <leader>ft :BTags<CR>
nnoremap <leader>fT :Tags<CR>
nnoremap <leader>f/ :History/<CR>
nnoremap <leader>f: :History:<CR>
nnoremap <leader>fH :History<CR>
nnoremap <leader>fc :Commands<CR>
nnoremap <leader>fm :Maps<CR>
nnoremap <leader>fs :Snippets<CR>
inoremap <F11>sn <C-o>:Snippets<CR>
nnoremap <F11>sn :Snippets<CR>
nnoremap <leader>fh :Helptags<CR>
nnoremap <leader>cmd :Commands<CR>
nnoremap <leader>ffty :Filetypes<CR>

nnoremap <silent> <F3>aw :Ag <C-R><C-W><CR>
nnoremap <silent> <F3>aW "zyiW:Ag <C-R>z<CR>
vnoremap <silent> <F3>aw "zy:Ag <C-R>z<CR>
vnoremap <silent> <F3>ag "zy:new <bar> grep -RF '<C-R>z' --include='*' .<Left><Left><Left>
nmap <silent> <F3>a/ :Ag <C-r>/<CR>

" Mapping selecting mappings
nmap <leader>f<Space> <plug>(fzf-maps-n)
xmap <leader>f<Space> <plug>(fzf-maps-x)
omap <leader>f<Space> <plug>(fzf-maps-o)
omap <leader>f<Space> <plug>(fzf-maps-o)
" Insert mode completion
imap <c-f><c-f> <plug>(fzf-complete-path)
imap <c-f><c-j> <plug>(fzf-complete-file-ag)
imap <c-f><c-l> <plug>(fzf-complete-line)

" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }

" Advanced customization using autoload functions
" inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})

" Custom commands :) =================================================
"
" how to further adapt: https://github.com/junegunn/fzf.vim/issues/92
autocmd! VimEnter * command! -nargs=* AgReduced :call fzf#vim#ag_raw('-U ' . <q-args>)
if executable('rg')
    " Similarly, we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
    command! -bang -nargs=* Ag
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
      \   <bang>0 ? fzf#vim#with_preview('up:60%')
      \           : fzf#vim#with_preview('right:50%:hidden', '?'),
      \   <bang>0)
elseif executable('ag')
    command! -bang -nargs=* Ag
      \ call fzf#vim#ag(<q-args>, 
      \                 <bang>0 ? fzf#vim#with_preview('up:60%')
      \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
      \                 <bang>0)
endif

" Likewise, Files command with preview window
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" Colors



" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = g:UnmanagedDataFolder('fzf-history')

" How to adapt... ============================================

" --- tags on word selection, from https://github.com/junegunn/fzf.vim/issues/50 
" Nice, you can further simplify the code like follows, no need for if-else branch:
" call fzf#vim#tags({'options': '-q '.shellescape(expand('<cword>'))})
" Note that :Tags command passes layout option as well.
" call fzf#vim#tags({'options': '-q '.shellescape(expand('<cword>')), 'down': '~40%'})

" raw methods let adapt arguments
" https://github.com/junegunn/fzf.vim/issues/51
