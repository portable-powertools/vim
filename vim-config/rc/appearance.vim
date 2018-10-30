set laststatus=2
"" Disable the blinking cursor.
set gcr=a:blinkon0
set scrolloff=6
" set textwidth=79
set wildmenu
" set wildmode=longest,list

autocmd VimEnter * RainbowParentheses

" RainbowParentheses
" Deactivate :RainbowParentheses!  " Toggle :RainbowParentheses!!
nnoremap <F11>rb :RainbowParentheses!!<CR>

"Flagship
autocmd User Flags call Hoist("window", "|b#%-10.3n|")
" autocmd User Flags call Hoist("window", "|cwd>%{pathshorten(getcwd())}|")
set laststatus=2
set showtabline=2
set guioptions-=e
let g:tablabel = "%N%{flagship#tabmodified()} %{flagship#tabcwds('shorten',',')}"


" IndentLine
let g:indentLine_enabled = 1
let g:indentLine_concealcursor = 0
let g:indentLine_char = '┆'
let g:indentLine_faster = 0 "TODO: lol. 'may bring little issue with it' when 1

" " TODO: what exactly does this do, againr
" set title
" set titleold="Terminal"
" set titlestring=%F

set number
" show active line only for the active window 
augroup CursorLine
    au!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END


:noh


" Color Scheme

" COLORS
" set termguicolors
let g:CSApprox_loaded = 1

if $COLORTERM == 'gnome-terminal'
    set term=gnome-256color
else
    if $TERM == 'xterm'
    set term=xterm-256color
    endif
endif
let g:solarized_termcolors=256


" needed?
set t_Co=256
if !exists("g:syntax_on")
    syntax enable
endif

" DEFAULT THEME
    " set background=light
    " colorscheme default " not bad actually in light variant

    " Background transparent hack
    " hi Normal guibg=NONE ctermbg=NONE

set background=light
colorscheme PaperColor " solarized8
