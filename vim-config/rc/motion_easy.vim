let g:EasyMotion_startofline=1
let g:EasyMotion_do_shade=1
let g:EasyMotion_enter_jump_first = 1
let g:EasyMotion_use_upper = 1
    let g:EasyMotion_use_upper = 1
    let g:EasyMotion_keys = 'ASDFGHJKLQWERTYUIOPZXCVBNM'
nmap s         <Plug>(easymotion-s2)
xmap s         <Plug>(easymotion-s2)
omap z         <Plug>(easymotion-s2)
nmap <Leader>s <Plug>(easymotion-sn)
xmap <Leader>s <Plug>(easymotion-sn)
" omap <Leader>z <Plug>(easymotion-sn)
nmap <Leader><Leader>; <Plug>(easymotion-next)
nmap <Leader><Leader>: <Plug>(easymotion-prev)
vmap <Leader><Leader>; <Plug>(easymotion-next)
vmap <Leader><Leader>: <Plug>(easymotion-prev)

" Bidirectional easymotions 
map  <Leader>F <Plug>(easymotion-bd-f)
omap  <Leader>F <Plug>(easymotion-bd-f)
map  <Leader>w <Plug>(easymotion-bd-w)
" Overwin 2-target and word
map <Leader><Leader>of <Plug>(easymotion-overwin-f)
map <Leader><Leader>ow <Plug>(easymotion-overwin-w)
map <Leader><Leader>os <Plug>(easymotion-overwin-f2)
nmap <Leader><Leader>o<DOWN> <Plug>(easymotion-overwin-line)

" VIMapping
xmap <Up> <Plug>(easymotion-sol-bd-jk)
omap <Up> <Plug>(easymotion-sol-bd-jk)
map <Up> <Plug>(easymotion-sol-bd-jk)

xmap <Leader><Home> <Plug>(easymotion-sol-bd-jk)
omap <Leader><Home> <Plug>(easymotion-sol-bd-jk)
map <Leader><Home> <Plug>(easymotion-sol-bd-jk)

map <Leader><Leader><Home> <Plug>(easymotion-overwin-line)

" nmap <Leader><Leader><Down> <Plug>(easymotion-jumptoanywhere)


" :h g:incsearch#auto_nohlsearch
set hlsearch " DO NOT DISABLE
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)<Plug>(incsearch-nohl-N)
map #  <Plug>(incsearch-nohl-#)<Plug>(incsearch-nohl-N)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

"--------------
" Incsearch replacing default search
map g/ m`<Plug>(incsearch-forward)
map ? m`<Plug>(incsearch-stay)
map / m`<Plug>(incsearch-nohl)<F10>__search

" TODO: works, but maybe get incsearch working? Workarounds for not using the incsearch commandsline
" this invokes vanilla search, see mapping above
nnoremap <F10>__search /
" This can be maaped to by something that wants to have highlight but vanish on movement
nmap <F10>__hl :set hlsearch<CR><Plug>(incsearch-nohl0)
" nmap <silent> <F10>__hl :keepj exec "normal m`\<Plug>(incsearch-nohl-n)``"<CR>

" incsearch + easymotion are my defaults now <3
map zg/ m`<Plug>(incsearch-easymotion-/)
map z? m`<Plug>(incsearch-easymotion-?)
map z/ m`<Plug>(incsearch-easymotion-stay)
" --------
 
