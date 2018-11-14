"Plugin: vimple
"what the fuck vimple get off my insert mode
imap <F5>~~ <plug>vimple_completers_trigger
let vimple_auto_filter = []
" Execute the visual selection
nmap <F10>v :call g:VForVimpdetta('cursor', 'onlyLine')<CR>
" :View the visual selection expression
nmap <F10>V :call g:VForVimpdetta('lineExecSimple', 'cursor', 'onlyLine')<CR>
" take line 'v as View arg
nmap <F10><F10><F10>v :call g:VForVimpdetta('onlyAbove')<CR>
nmap <F10><F10><F10>V :source %<CR>
nmap <F10><F10>v :call g:VForVimpdetta()<CR>
nmap <F10><F10>V :call g:VForVimpdetta('lineExecSimple')<CR>


fun! g:VForVimpdetta(...) abort
    let a:options = get(a:, 1, [])
    let vpos = g:GetVisualPos()
    let pos = getcurpos()
    
    let linepos = "'v"
    if index(a:000, 'cursor') != -1
        let linepos = '.'
    endif
    let abovelines = getline(1, linepos)
    let vline = remove(abovelines, -1)
    let abovelines = join(abovelines, "\n")

    " abovelines are always executed
    if index(a:000, 'onlyLine') == -1
        call setreg('z', substitute(abovelines, '\v\n\s*\\', '', 'g'))
        echom '/////z: '.getreg('z')
        exec "normal :@z\<CR>"
    endif

    if index(a:000, 'onlyAbove') == -1
        if index(a:000, 'lineExecSimple') != -1
            exec vline
        else
            let execstr = printf('View %s', escape(vline, '"'))
            exec "normal :".execstr."\<CR>"
        endif

    endif
endf
