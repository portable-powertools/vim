call plug#begin(g:vimplugindir)

" Core functionality
        " libraries

        Plug 'xolox/vim-misc'
        Plug 'luchermitte/lh-vim-lib'

        Plug 'tpope/vim-commentary'
        " Core, small impact
        Plug 'tpope/vim-eunuch'
        Plug 'tpope/vim-sensible'
        Plug 'tpope/vim-surround'
        Plug 'tpope/vim-repeat'
        Plug 'tpope/vim-unimpaired'
        Plug '907th/vim-auto-save'
        Plug 'svermeulen/vim-easyclip'
        Plug 'tpope/vim-flagship'
        Plug 'breuckelen/vim-resize'
        Plug 'mhinz/vim-grepper'
        Plug 'vim-scripts/TaggedSearchPattern'

        " Text objects and functionality
        Plug 'kana/vim-textobj-user' | Plug 'kana/vim-textobj-line' | Plug 'kana/vim-textobj-entire' | Plug 'kana/vim-textobj-indent' | Plug 'kana/vim-textobj-lastpat'
        Plug 'kana/vim-operator-user'
        Plug 'kana/vim-operator-replace'
        Plug 'bps/vim-textobj-python'
        Plug 'sgur/vim-textobj-parameter'
        Plug 'Yggdroot/indentLine'
        Plug 'terryma/vim-expand-region'
        Plug 'andrewradev/splitjoin.vim'
        Plug 'tommcdo/vim-ninja-feet'
        
        " ... sessions, buffers, ...
        Plug 'xolox/vim-session', Cond(1)
        Plug 'simlei/vim-localvimrc'
        Plug 'simlei/vim-tabpagecd'
        Plug 'airblade/vim-rooter'
        Plug 'rbong/vim-buffest'

" -- more sophisticated
        Plug 'dahu/vimple'
        
        " Snips
        Plug 'SirVer/ultisnips'
        Plug 'portable-powertools/vim-snippets'

        Plug 'tmhedberg/SimpylFold', Cond(1)
        Plug 'vim-voom/VOoM'
        Plug 'machakann/vim-Verdin' " TODO: test
        Plug 'Valloric/YouCompleteMe'
        Plug 'sheerun/vim-polyglot'
        Plug 'w0rp/ale'

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
" folding etc
        Plug 'zhimsel/vim-stay'
        Plug 'simlei/searchfold.vim'
" -- window arrangement
        Plug 'szw/vim-maximizer'
        Plug 'andymass/vim-tradewinds'
        Plug 'AndrewRadev/undoquit.vim'
        Plug 'arithran/vim-delete-hidden-buffers'
        Plug 'moll/vim-bbye'
        Plug 't9md/vim-choosewin'
        Plug 'vim-scripts/ProportionalResize', Cond(1)
        Plug 'zhaocai/GoldenView.Vim', Cond(1)
" -- utilities
        Plug 'majutsushi/tagbar'
        Plug 'justinmk/vim-dirvish'
        Plug 'mtth/scratch.vim', Cond(1)
        Plug 'mbbill/undotree'
        Plug 'francoiscabrol/ranger.vim'
        Plug 'simlei/vim-bookmarks', Cond(0) " TODO: keep this? its rc file is not sourced right now btw.
        " Quickfix zoo
        Plug 'romainl/vim-qf', Cond(1)
        Plug 'yssl/QFEnter', Cond(1)
        Plug 'jceb/vim-editqf', Cond(1) " can add notes and save, but almost all that romainl's plug cando too


" is order important?
        Plug 'Konfekt/FastFold', Cond(1)

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
        Plug 'tyru/open-browser.vim'
        Plug 'jceb/vim-hier', Cond(0) " Higlights the quickfix entries. Coooould be useful but not right now.
        Plug 'andymass/vim-matchup', Cond(0) " TODO: no python support yet, but look into that later!
        Plug 'tweekmonster/braceless.vim'
        Plug 'kshenoy/vim-signature'
        
" look at it later again...
"


        " looks good so far          =========================================
        Plug 'ludovicchabant/vim-gutentags'

" -- not so valuable, but may get better with config
        " Plug 'kana/vim-smartinput'

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

            " Plug 'lifepillar/vim-cheat40'
            " Plug 'junegunn/vim-peekaboo'
        " Plug 'unblevable/quick-scope'
