call plug#begin(g:vimplugindir)

" Core functionality

        " Core, small impact
        Plug 'tpope/vim-eunuch'
        Plug 'tpope/vim-sensible'
        Plug 'tpope/vim-surround'
        Plug 'tpope/vim-commentary'
        Plug 'tpope/vim-repeat'
        Plug 'breuckelen/vim-resize'
        Plug 'regedarek/ZoomWin'
        Plug 'arithran/vim-delete-hidden-buffers'
        Plug 'Valloric/ListToggle'
        Plug 'moll/vim-bbye'
        Plug '907th/vim-auto-save'
        Plug 'mtth/scratch.vim' " not unproblematic but should stay. TODO: permanence toggle working right
        Plug 'drmikehenry/vim-fontsize'

        " has UI tho
        Plug 'lifepillar/vim-cheat40'
        Plug 't9md/vim-choosewin'
        Plug 'majutsushi/tagbar'
        Plug 'justinmk/vim-dirvish'
        " Plug 'junegunn/vim-peekaboo'

        " Text objects and functionality
        Plug 'Yggdroot/indentLine'
        Plug 'zirrostig/vim-schlepp' 
        Plug 'kana/vim-textobj-user' | Plug 'kana/vim-textobj-line' | Plug 'kana/vim-textobj-entire' | Plug 'kana/vim-textobj-indent'
        Plug 'vim-scripts/argtextobj.vim'
        Plug 'andrewradev/sideways.vim'
        Plug 'terryma/vim-expand-region'
        
        " ... sessions, buffers, ...
        Plug 'luchermitte/lh-vim-lib'
        Plug 'xolox/vim-session'
        Plug 'xolox/vim-misc'
        Plug 'embear/vim-localvimrc'
        Plug 'kana/vim-tabpagecd'
        Plug 'airblade/vim-rooter'

" -- Core, sophisticated

        Plug 'svermeulen/vim-easyclip' " TODO: Still problems but cant do without it...
        
        " Snips
        Plug 'SirVer/ultisnips'
        Plug 'portable-powertools/vim-snippets'
        
        " language features
        Plug 'machakann/vim-Verdin' " TODO: test
        Plug 'Valloric/YouCompleteMe'
        Plug 'sheerun/vim-polyglot'
        Plug 'w0rp/ale'
        Plug 'ludovicchabant/vim-gutentags'

        " fancy motion 
        Plug 'haya14busa/incsearch.vim'
        Plug 'easymotion/vim-easymotion'
        Plug 'haya14busa/incsearch-easymotion.vim'
        Plug 'unblevable/quick-scope'

        " side windows and the like, purely for comfort
        Plug 'mbbill/undotree'
        Plug 'francoiscabrol/ranger.vim'
        Plug 'simlei/vim-bookmarks'

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

        
" Visual
        Plug 'tpope/vim-flagship'
        Plug 'NLKNguyen/papercolor-theme'
        Plug 'junegunn/rainbow_parentheses.vim'

" On Probatiop
        " looks good so far          =========================================
        Plug 'foosoft/vim-argwrap' " TODO: test with python and splitjoin overlap
        Plug 'andrewradev/splitjoin.vim' " TODO: test with python and argwrap overlap

        Plug 'tpope/vim-abolish' " coerce cases is nice! no problems til date but major features (substitution, autocorrection) still unexplored
        " Plug 'kopischke/vim-stay' "TODO: see how much UnmanagedDataFolde space it consumes and if it works nice without.
" Testing...
        Plug 'metakirby5/codi.vim'
        Plug 'vim-scripts/ProportionalResize'
        " Plug 'roman/golden-ratio'
        Plug 'zhaocai/GoldenView.Vim'
        " linkstash, never tested... ==========================================
        Plug 'direnv/direnv.vim', Cond(executable('direnv') && 0) " TODO: test effects with direnv, touchstone, etc thoroughly before enabling!
        " Plug 'freitass/todo.txt-vim'
        " Plug 'lambdalisue/vim-pyenv'
        
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
