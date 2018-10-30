let mapleader = ","
" this remaps backward motion. let it be:
noremap <Leader>; ,

let localleader = "<"

set smartcase
set ignorecase

set modeline
set modelines=5

filetype plugin indent on
set nobackup
set fileformats=unix,dos,mac
set noswapfile
set splitbelow
set splitright
set ttyfast
set smartindent
set showcmd
set backspace=indent,eol,start
set showtabline=2
set hidden
"" Encoding
set encoding=utf-8
set fileencodings=utf-8
" set bomb
set ttyfast

"" Tabs. May be overriten by autocmd rules
set expandtab
set tabstop=4
set softtabstop=0
set shiftwidth=4
set expandtab
set list listchars=tab:→\ ,trail:·
