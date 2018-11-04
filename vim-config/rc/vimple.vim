"Plugin: vimple
"what the fuck vimple get off my insert mode
imap <F5>~~ <plug>vimple_completers_trigger
let vimple_auto_filter = []
" Execute the visual selection
vmap <F10>v :<C-u><C-r>=g:Get_visual_selection()<CR><CR>
" :View the visual selection expression
vmap <F10>E :<C-u><C-r>=escape(g:Get_visual_selection(), '<bar>')<CR><Home>View echo string(<End>)
vmap <F10>V :<C-u><C-r>=escape(g:Get_visual_selection(), '<bar>')<CR><Home>View <CR>
" take line 'v as View arg
nmap <F10><F10>v :echo 'hi???'<CR>:call g:VForVimpdetta()<CR>
" nmap <F10><F10>v 'vV:<C-u>let @z=g:GVS()<CR>:1,'<-1y x<CR>:@x<CR>:<C-u><C-r>=escape(@z, '"')<CR><Home>View <CR><C-w>p<C-o><C-o>
" execute everything above the visual selection, then :View the visual selection expression
vmap <F10><F10>v :<C-u>let @z=g:GVS()<CR>:1,'>-1y x<CR>:@x<CR>:<C-u><C-r>=escape(@z, '<bar>')<CR><Home>View <CR>
vmap <F10>C :<C-u><C-r>=g:Get_visual_selection()<CR><Home>Collect  <Left>

" TODO doesnt work yet -- but other stuf neither..t
" vmap <F10><F10>G :<C-u><C-r>=trim(escape(g:Get_visual_selection(), "'"))<CR><Home>View GCollect('<End>')
" vmap <F10>G :<C-u><C-r>=trim(escape(g:Get_visual_selection(), "'"))<CR><Home>View GCollect('<End>')

fun! g:VForVimpdetta() abort
    let vpos = g:GetVisualPos()
    let pos = getcurpos()
    exec "norm 'vV"
    norm 
    let @x = escape(g:GVS(), '"')
    exec "norm ggV'vk"
    norm 
    let @z = g:GVS()
    call call('g:SetVisualPos', vpos)
    call setpos('.', pos)

    keepj exec "normal :@z\<CR>"
    exec "normal :View \<C-r>x\<CR>"
endf
