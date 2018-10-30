
let g:EasyMotion_enter_jump_first = 1
let g:EasyMotion_use_upper = 1
    let g:EasyMotion_use_upper = 1
    let g:EasyMotion_keys = 'ASDFGHJKLQWERTYUIOPZXCVBNM'
nmap s         <Plug>(easymotion-s2)
xmap s         <Plug>(easymotion-s2)
omap z         <Plug>(easymotion-s2)
nmap <Leader>s <Plug>(easymotion-sn)
xmap <Leader>s <Plug>(easymotion-sn)
omap <Leader>z <Plug>(easymotion-sn)
nmap <Leader><Leader>; <Plug>(easymotion-next)
nmap <Leader><Leader>: <Plug>(easymotion-prev)
vmap <Leader><Leader>; <Plug>(easymotion-next)
vmap <Leader><Leader>: <Plug>(easymotion-prev)

" Bidirectional easymotions 
map  <Leader>ff <Plug>(easymotion-bd-f)
omap  <Leader>ff <Plug>(easymotion-bd-f)
map <Leader>L <Plug>(easymotion-bd-jk)
map  <Leader>w <Plug>(easymotion-bd-w)
" Overwin 2-target and word
map <Leader><Leader>os <Plug>(easymotion-overwin-f2)
nmap <Leader><Leader>ow <Plug>(easymotion-overwin-w)


" :h g:incsearch#auto_nohlsearch
set hlsearch
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)<Plug>(incsearch-nohl-N)
map #  <Plug>(incsearch-nohl-#)<Plug>(incsearch-nohl-N)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

"--------------
" Incsearch replacing default search
map g/ mz<Plug>(incsearch-forward)
map ? mz<Plug>(incsearch-backward)
map / :let g:lastsearch = getreg('/')<CR>mz<Plug>(incsearch-stay)
" incsearch + easymotion are my defaults now <3
map zg/ mz<Plug>(incsearch-easymotion-/)
map z? mz<Plug>(incsearch-easymotion-?)
map z/ mz<Plug>(incsearch-easymotion-stay)
" --------
 
