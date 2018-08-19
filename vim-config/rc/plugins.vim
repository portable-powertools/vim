call plug#begin(g:vimplugindir)

" Core functionality

        " Core, small impact
        Plug 'tpope/vim-eunuch'
        Plug 'tpope/vim-sensible'
        Plug 'tpope/vim-surround'
        Plug 'tpope/vim-commentary'
        Plug 'tpope/vim-repeat'
        Plug '907th/vim-auto-save'
        Plug 'zirrostig/vim-schlepp' 
        Plug 'svermeulen/vim-easyclip' "
        Plug 'tpope/vim-flagship'
        Plug 'Valloric/ListToggle'

        " Text objects and functionality
        Plug 'kana/vim-textobj-user' | Plug 'kana/vim-textobj-line' | Plug 'kana/vim-textobj-entire' | Plug 'kana/vim-textobj-indent'
        Plug 'kana/vim-operator-user'
        Plug 'kana/vim-operator-replace'
        Plug 'kana/vim-textobj-function'
        Plug 'bps/vim-textobj-python'
        Plug 'vim-scripts/argtextobj.vim'
        Plug 'Yggdroot/indentLine'
        Plug 'terryma/vim-expand-region'
        
        " ... sessions, buffers, ...
        Plug 'xolox/vim-session'
        Plug 'xolox/vim-misc'
        Plug 'embear/vim-localvimrc'
        Plug 'kana/vim-tabpagecd'
        Plug 'airblade/vim-rooter'

" -- more sophisticated
        Plug 'kana/vim-smartinput'
        
        " Snips
        Plug 'SirVer/ultisnips'
        Plug 'portable-powertools/vim-snippets'
        
        " language features
        Plug 'metakirby5/codi.vim'
        Plug 'machakann/vim-Verdin' " TODO: test
        Plug 'Valloric/YouCompleteMe', Cond(1)
        Plug 'sheerun/vim-polyglot'
        Plug 'w0rp/ale', Cond(1)

        " fancy motion 
        Plug 'andrewradev/sideways.vim'
        Plug 'haya14busa/incsearch.vim'
        Plug 'easymotion/vim-easymotion'
        Plug 'haya14busa/incsearch-easymotion.vim'

        " side windows and the like, purely for comfort

        
" Visual
        Plug 'drmikehenry/vim-fontsize'
        Plug 'NLKNguyen/papercolor-theme'
        Plug 'junegunn/rainbow_parentheses.vim'
" UX / visual
" -- window arrangement
        Plug 'zhaocai/GoldenView.Vim'
        Plug 'vim-scripts/ProportionalResize'
        Plug 'szw/vim-maximizer'
        Plug 'breuckelen/vim-resize'
        Plug 'andymass/vim-tradewinds'
        Plug 'AndrewRadev/undoquit.vim'
        Plug 'arithran/vim-delete-hidden-buffers'
        Plug 'moll/vim-bbye'
        Plug 't9md/vim-choosewin'
" -- utilities
        Plug 'majutsushi/tagbar'
        Plug 'justinmk/vim-dirvish'
        Plug 'mtth/scratch.vim'
        Plug 'mbbill/undotree'
        Plug 'francoiscabrol/ranger.vim'
        Plug 'simlei/vim-bookmarks'


" =======
        " FZF : TODO: check whether fzfdir is set 
        Plug 'junegunn/fzf.vim', Cond(executable('fzf') && ! empty(g:fzfdir))
        if (! empty(g:fzfdir)) 
            Plug g:fzfdir, Cond(executable('fzf'))
        else
            if (! executable('fzf')) 
                echom 'no fzf executable found on the PATH, the FZF plugin is not available.'
            endif
            echom 'the fzf software directory could not be located on disc, therefore fzf is notavailable.'
        endif
" =======

" On Probatiop
        " looks good so far          =========================================
        Plug 'andrewradev/splitjoin.vim' " TODO: test with python and argwrap overlap
        Plug 'ludovicchabant/vim-gutentags'

" Testing...
        " linkstash, never tested... ==========================================
        " Plug 'freitass/todo.txt-vim'
        
        " For future reference... ==========================================
        
        " ===== C, additionally to YCM
        " Plug 'vim-scripts/c.vim', {'for': ['c', 'cpp']}
        " ===== Scala 
        " if has('python')
        "     Plug 'ktvoelker/sbt-vim'
        " endif
        " Plug 'derekwyatt/vim-scala'
        
        " Plug 'vim-scripts/CSApprox'

        "TODO: make own slime plugin
        " Plug 'simlei/vim-slime'

call plug#end()


" ==== Graveyard

            " Plug 'luchermitte/lh-vim-lib' # just to not loose it if turns out i still use a function
            " Plug 'lifepillar/vim-cheat40'
            " Plug 'junegunn/vim-peekaboo'
        " Plug 'unblevable/quick-scope'
