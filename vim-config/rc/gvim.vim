" gvim term mode emulation
if has("gui_running")
    set winaltkeys=no
    let s:printable_ascii = map(range(32, 126), 'nr2char(v:val)')
    call remove(s:printable_ascii, 92)
    for s:char in s:printable_ascii
        execute "imap <A-" . s:char . "> <Esc>" . s:char
        execute "map <A-" . s:char . "> <Esc>" . s:char
        execute "tmap <A-" . s:char . "> <Esc>" . s:char
    endfor
    unlet s:printable_ascii s:char
endif

