nnoremap <F10>us :UltiSnipsEdit<CR>
nnoremap <F10>uS :UltiSnipsEdit!<CR>

let g:UltiSnipsRemoveSelectModeMappings = 0
" workaround selection mode yanking (undesirable)
let s:printable_ascii = map(range(32, 126), 'nr2char(v:val)')
set winaltkeys=no
call remove(s:printable_ascii, 92)
for s:char in s:printable_ascii
    execute "smap " . s:char . " <C-g>c"
    " execute "vmap " . s:char . " <C-g>c"
    " execute "smap " . s:char . " <C-g>c" . s:char
endfor
unlet s:printable_ascii s:char

" not needed anymore :)
" let g:lastUSVictims = []
" fun! g:PushUSS()
"     let g:lastUSVictims = add(g:lastUSVictims, @+)
"     echom "pushed, " . join(g:lastUSVictims, ';')
" endf
" fun! g:PopUSS()
"     if len(g:lastUSVictims) > 0
"         let l:result = g:lastUSVictims[-1]
"         let g:lastUSVictims = g:lastUSVictims[0:-2]
"         let @+ = l:result
"         return l:result
"     else
"         return
"     endif
" endf
" map <Leader>us :call g:PopUSS() <bar> echo @+<CR>

" autocmd! User UltiSnipsEnterFirstSnippet
" autocmd User UltiSnipsEnterFirstSnippet call g:PushUSS()
" autocmd! User UltiSnipsExitLastSnippet
" autocmd User UltiSnipsExitLastSnippet call g:PopUSS()
" augroup ultisnipsRescueClipboard
"     au!
"     autocmd! User UltiSnipsEnterFirstSnippet
"     autocmd User UltiSnipsEnterFirstSnippet call g:PushUSS()
"     autocmd! User UltiSnipsExitLastSnippet
"     autocmd User UltiSnipsExitLastSnippet call g:PopUSS()
" augroup END
