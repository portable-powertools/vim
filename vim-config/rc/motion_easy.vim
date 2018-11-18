let g:EasyMotion_startofline=1
let g:EasyMotion_do_shade=0
let g:EasyMotion_enter_jump_first = 1
let g:EasyMotion_use_upper = 1
let g:EasyMotion_use_upper = 1
let g:EasyMotion_keys = 'ASDFGHJKLQWERTYUIOPZXCVBNM'
hi link EasyMotionMoveHL Search
hi link EasyMotionIncSearch Search
let g:EasyMotion_move_highlight = 1

"""""""""""""""""""""""""""""
"  normal VIM motion stuff  "
"""""""""""""""""""""""""""""
" TODO candidate for statemachine stuff to unify

" Umgewoehnung, make space for those as leaders


nmap s         <Plug>(easymotion-s2)
xmap s         <Plug>(easymotion-s2)
omap z         <Plug>(easymotion-s2)
nmap <Leader>s <Plug>(easymotion-sn)
xmap <Leader>s <Plug>(easymotion-sn)
" omap <Leader>z <Plug>(easymotion-sn)

" Bidirectional easymotions, shifted = whole buf 



map  <Leader>t <Plug>(easymotion-bd-tl)
omap  <Leader>t <Plug>(easymotion-bd-tl)
map  <Leader>T <Plug>(easymotion-bd-t)
omap  <Leader>T <Plug>(easymotion-bd-t)
map  <Leader>f <Plug>(easymotion-bd-fl)
omap  <Leader>f <Plug>(easymotion-bd-fl)
map  <Leader>F <Plug>(easymotion-bd-f)
omap  <Leader>F <Plug>(easymotion-bd-f)
map  <Leader>w <Plug>(easymotion-bd-wl)
omap  <Leader>w <Plug>(easymotion-bd-wl)
map  <Leader>W <Plug>(easymotion-bd-w)
omap  <Leader>W <Plug>(easymotion-bd-w)
map  <Leader>e <Plug>(easymotion-bd-el)
omap  <Leader>e <Plug>(easymotion-bd-el)
map  <Leader>E <Plug>(easymotion-bd-e)
omap  <Leader>E <Plug>(easymotion-bd-e)
map  <Leader>ge <Plug>(easymotion-bd-el)
omap  <Leader>e <Plug>(easymotion-bd-el)
map  <Leader>E <Plug>(easymotion-bd-e)
omap  <Leader>E <Plug>(easymotion-bd-e)


" half as fast PgUp/down events
nnoremap <PageUp> <C-u>
nnoremap <PageDown> <C-d>
" arrange at top/bottom
nnoremap z<PageUp> z-
nnoremap z<PageDown> zt
vnoremap z<PageUp> <Esc>'>z-gv
vnoremap z<PageDown> <Esc>'<ztgv

" Overwin:
map <Leader><Leader>f <Plug>(easymotion-overwin-f)
map <Leader><Leader>w <Plug>(easymotion-overwin-w)
map <Leader><Leader>s <Plug>(easymotion-overwin-f2)
nmap <Leader><Leader><Insert> <Plug>(easymotion-overwin-line)

" Linemovements:

xmap <Insert> <Plug>(easymotion-sol-bd-jk)
omap <Insert> <Plug>(easymotion-sol-bd-jk)
nmap <Insert> <Plug>(easymotion-sol-bd-jk)
xmap <Up> <Plug>(easymotion-sol-k)
omap <Up> <Plug>(easymotion-sol-k)
nmap <Up> <Plug>(easymotion-sol-k)
xmap <Down> <Plug>(easymotion-sol-j)
omap <Down> <Plug>(easymotion-sol-j)
nmap <Down> <Plug>(easymotion-sol-j)

let g:easymotion_repos_flash = 40
" Linemovements: with Viewport change
" TODO omap doesnt seem to like rerendering the window due to zz and colleagues, no big loss though " omap <Leader><Insert> :<C-u>exec "normal zz" <bar> redraw <bar> call feedkeys("<Plug>(easmotion-sol-bd-jk)"<CR>
" TEMPLATE:
" vmap ${1:<Leader><Insert>} <Esc>${2:zz}:call g:FlashLine(line('.'), 1, ${3:flashtime}) <bar> call feedkeys("gv\<Plug>(easymotion-${4:sol-bd-jk})")<CR>
" nmap $1 $2:call g:FlashLine(line('.'), 1, $3) <bar> call feedkeys("\<Plug>(easymotion-$4)")<CR>
" ----
vmap <Leader><Insert> <Esc>zz:call g:FlashLine(line('.'), 1, g:easymotion_repos_flash) <bar> call feedkeys("gv\<Plug>(easymotion-sol-bd-jk)")<CR>
nmap <Leader><Insert> zz:call g:FlashLine(line('.'), 1, g:easymotion_repos_flash) <bar> call feedkeys("\<Plug>(easymotion-sol-bd-jk)")<CR>
vmap <Leader><Up> <Esc>z-:call g:FlashLine(line('.'), 1, g:easymotion_repos_flash) <bar> call feedkeys("gv\<Plug>(easymotion-sol-k)")<CR>
nmap <Leader><Up> z-:call g:FlashLine(line('.'), 1, g:easymotion_repos_flash) <bar> call feedkeys("\<Plug>(easymotion-sol-k)")<CR>
vmap <Leader><Down> <Esc>zt:call g:FlashLine(line('.'), 1, g:easymotion_repos_flash) <bar> call feedkeys("gv\<Plug>(easymotion-sol-j)")<CR>
nmap <Leader><Down> zt:call g:FlashLine(line('.'), 1, g:easymotion_repos_flash) <bar> call feedkeys("\<Plug>(easymotion-sol-j)")<CR>


" 
" xmap <Leader><Home> <Plug>(easymotion-sol-bd-jk)
" omap <Leader><Home> <Plug>(easymotion-sol-bd-jk)
" nmap <Leader><Home> <Plug>(easymotion-sol-bd-jk)


" nmap <Leader><Leader>e <Plug>(easymotion-jumptoanywhere)


set hlsearch " DO NOT DISABLE
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)<Plug>(incsearch-nohl-N)
map #  <Plug>(incsearch-nohl-#)<Plug>(incsearch-nohl-N)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

"--------------
" Incsearch: replacing default search
map ? m`<Plug>(incsearch-stay)
map / m`<Plug>(incsearch-nohl)<F10>__search
" incsearch + easymotion
map <Leader>/ m`<Plug>(incsearch-easymotion-stay)
" map z? m`<Plug>(incsearch-easymotion-?)
map <Leader><Leader>/ m`<Plug>(incsearch-easymotion-/)


" Workaround:
" TODO: works, but maybe get incsearch working? Workarounds for not using the incsearch commandsline
" this invokes vanilla search, see mapping above
nnoremap <F10>__search /
" This can be maaped to by something that wants to have highlight but vanish on movement
nmap <F10>__hl :set hlsearch<CR><Plug>(incsearch-nohl0)
" nmap <silent> <F10>__hl :keepj exec "normal m`\<Plug>(incsearch-nohl-n)``"<CR>

" --------
 
