command! -nargs=* KeepName call g:WithVar('g:qf_bufname_or_text', 1, 'Keep '.<q-args>)
command! -nargs=* KeepCont call g:WithVar('g:qf_bufname_or_text', 2, 'Keep '.<q-args>)
command! -nargs=* KeepBoth call g:WithVar('g:qf_bufname_or_text', 0, 'Keep '.<q-args>)


" All quickfix window
let g:qf_auto_open_quickfix = 0
let g:qf_auto_open_loclist = 0
let g:qf_auto_resize = 0
let g:qf_auto_quit = 0
" nmap <Leader>aa; <Plug>(qf_loc_toggle)
nmap <Leader>c; <Plug>(qf_qf_toggle)
nnoremap <Leader>cj :cnext<CR>
nnoremap <Leader>ck :cprevious<CR>
nnoremap <Leader>caj :lnext<CR>
nnoremap <Leader>cak :lprevious<CR>

" Plugin: qfenter
let g:qfenter_enable_autoquickfix = 0

" Plugin: qf plugin settings
let g:qf_max_height = 20

" Plugin: Fzf, quickfix stuff

    " An action can be a reference to a function that processes selected lines
    function! s:build_quickfix_list(lines)
      call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
      copen
      cc
    endfunction

    let g:fzf_action = {
      \ 'ctrl-f': function('s:build_quickfix_list'),
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }

" Plugin: QFEnter

let g:qfenter_keymap = {}
let g:qfenter_keymap.open = ['<C-m>']
let g:qfenter_keymap.vopen = ['<Space>a']
let g:qfenter_keymap.hopen = ['<Space>o']
let g:qfenter_keymap.topen = ['<Space>t']
" all supported commands: open, vopen, hopen, topen, cnext, vcnext, hcnext, tcnext, cprev, vcprev, hcprev, tcprev, 
"

" Plugin: QFEdit

let g:editqf_no_mappings = 1
nmap <F10>qn <Plug>QFAddNote
nmap <F10>qpa <Plug>QFAddNotePattern
nmap <F10>qln <Plug>LocAddNote
nmap <F10>qlpa <Plug>LocAddNotePattern
let g:editqf_saveqf_filename  = "quickfix.list"
let g:editqf_saveloc_filename = "location.list"
let g:editqf_jump_to_error = 0
let g:editqf_store_absolute_filename = 1



" Filetype_commands:
autocmd FileType qf
\  nmap <silent><buffer> <Leader>m :.cc<CR><F10>__flash500<C-w>p
\| nmap <silent><buffer> J j:.cc<CR><F10>__flash300<C-w>p
\| nmap <silent><buffer> K k:.cc<CR><F10>__flash300<C-w>p
\| vmap <silent><buffer> <Leader>k "zy:<C-u>Keep <C-r>z<CR><C-w>L
\| vmap <silent><buffer> <Leader>r "zy:<C-u>Reject <C-r>z<CR><C-w>L
\| nmap <silent><buffer> <Leader>f ^vt|
