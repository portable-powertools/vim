augroup goldenratio
    au!
    autocmd VimEnter * EnableGoldenViewAutoResize
augroup end

let g:goldenview__enable_default_mapping = 0
let g:goldenview__enable_at_startup = 1
nmap <silent> <Leader>rs  <Plug>GoldenViewSplit
nmap <silent> <Leader>rj  <Plug>GoldenViewNext
nmap <silent> <Leader>rk  <Plug>GoldenViewPrevious
nmap <F11>rr <Plug>ToggleGoldenViewAutoResize
nmap <silent> <Leader>rr <Plug>GoldenViewResize

let g:goldenview__ignore_urule={
\   'filetype' : [
\     ''        ,
\     'qf'      , 'vimpager', 'undotree', 'tagbar',
\     'nerdtree', 'vimshell', 'vimfiler', 'voom'  ,
\     'tabman'  , 'unite'   , 'quickrun', 'Decho' ,
\     'ControlP', 'diff'    , 'extradite'
\   ],
\   'buftype' : [
\     'nofile'  , 'terminal'
\   ],
\   'bufname' : [
\     'GoToFile'                  , 'diffpanel_\d\+'      , 
\     '__Gundo_Preview__'         , '__Gundo__'           , 
\     '\[LustyExplorer-Buffers\]' , '\-MiniBufExplorer\-' , 
\     '_VOOM\d\+$'                , '__Urannotate_\d\+__' , 
\     '__MRU_Files__' , 'FencView_\d\+$'
\   ],
\ }


tmap <F11>rr <C-w>:ToggleGoldenViewAutoResize<CR>


