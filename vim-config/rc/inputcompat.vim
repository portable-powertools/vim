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

"""""""""""""""""""
"  f-keys compat  "
"""""""""""""""""""
set <F1>=OP
set <F2>=OQ
set <F3>=OR
set <F4>=OS
set <F5>=[15~
set <F6>=[17~
set <F7>=[18~
set <F8>=[19~
set <F9>=[20~
set <F10>=[21~
set <F11>=[23~
set <F12>=[24~

" set <F9>=?k9

" nmap ?k1 <F1>
" omap ?k1 <F1>
" imap ?k1 <F1>
" vmap ?k1 <F1>
" cmap ?k1 <F1>
" nmap ?k2 <F2>
" omap ?k2 <F2>
" imap ?k2 <F2>
" vmap ?k2 <F2>
" cmap ?k2 <F2>
" nmap ?k3 <F3>
" omap ?k3 <F3>
" imap ?k3 <F3>
" vmap ?k3 <F3>
" cmap ?k3 <F3>
" nmap ?k4 <F4>
" omap ?k4 <F4>
" imap ?k4 <F4>
" vmap ?k4 <F4>
" cmap ?k4 <F4>
" nmap ?k5 <F5>
" omap ?k5 <F5>
" imap ?k5 <F5>
" vmap ?k5 <F5>
" cmap ?k5 <F5>
" nmap ?k6 <F6>
" omap ?k6 <F6>
" imap ?k6 <F6>
" vmap ?k6 <F6>
" cmap ?k6 <F6>
" nmap ?k7 <F7>
" omap ?k7 <F7>
" imap ?k7 <F7>
" vmap ?k7 <F7>
" cmap ?k7 <F7>
" nmap ?k8 <F8>
" omap ?k8 <F8>
" imap ?k8 <F8>
" vmap ?k8 <F8>
" cmap ?k8 <F8>
" nmap ?k9 <F9>
" omap ?k9 <F9>
" imap ?k9 <F9>
" vmap ?k9 <F9>
" cmap ?k9 <F9>
" nmap ?k9 <F10>
" omap ?k9 <F10>
" imap ?k9 <F10>
" vmap ?k9 <F10>
" cmap ?k9 <F10>
" nmap ?k; <F11>
" omap ?k; <F11>
" imap ?k; <F11>
" vmap ?k; <F11>
" cmap ?k; <F11>
" nmap ?F1 <F12>
" omap ?F1 <F12>
" imap ?F1 <F12>
" vmap ?F1 <F12>
" cmap ?F1 <F12>
