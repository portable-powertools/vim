
let g:scratch_autohide = 0
let g:scratch_insert_autohide = 0
" let g:scratch_filetype = 'sh'
let g:scratch_height = 10
let g:scratch_top = 1
let g:scratch_horizontal = 1 " TODO: toggle

let g:scratch_persistence_file = '.scratch'
let g:scratch_persistence_always = 1
" if empty('g:scratch_persistence_file')
"     let g:scratch_persistence_file = ''
" endif

let g:scratch_no_mappings = 1
nnoremap <Leader>gs; :ScratchPreview<CR>
nnoremap <Leader>gss :Scratch<CR>
nnoremap <F11>sc :let g:scratch_autohide=!g:scratch_autohide <bar> echo 'Scratch autohide: '.g:scratch_autohide<CR>:ScratchPreview<CR>:ScratchPreview<CR><C-w>p

nmap <Leader>gs :Scratch<CR><C-w>p
nmap gs :Scratch<CR>
nmap gS :Scratch!<CR>
xmap <Leader>gs <plug>(scratch-selection-reuse)<C-w>p
xmap gs <plug>(scratch-selection-reuse)
xmap gS <plug>(scratch-selection-clear)

