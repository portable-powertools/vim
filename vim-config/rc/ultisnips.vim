command! -bang -nargs=0 Us UltiSnipsEdit<bang>
command! -bang -nargs=0 Ush exec 'normal ' . mapleader . 'h' | Us<bang> <args>
command! -bang -nargs=0 Usj exec 'normal ' . mapleader . 'j' | Us<bang> <args>
command! -bang -nargs=0 Usk exec 'normal ' . mapleader . 'k' | Us<bang> <args>
command! -bang -nargs=0 Usl exec 'normal ' . mapleader . 'l' | Us<bang> <args>

let g:UltiSnipsRemoveSelectModeMappings = 0


" " workaround selection mode yanking (undesirable)
" let s:printable_ascii = map(range(32, 126), 'nr2char(v:val)')
" call remove(s:printable_ascii, 92)
" for s:char in s:printable_ascii
"     execute "smap " . s:char . " <C-g>c"
" endfor
" unlet s:printable_ascii s:char

let s:i = 33

" Add a map for every printable character to copy to black hole register
" I see no easier way to do this
while s:i <= 126
    if s:i !=# 124
        let s:char = nr2char(s:i)
        if s:i ==# 92
          let s:char = '\\'
        endif
        execute "smap " . s:char . " <C-g>c" . s:char
    endif

    let s:i = s:i + 1
endwhile

smap <bs> <C-g>c
smap <space> <C-g>c<Space>
smap \| <C-g>c|
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
