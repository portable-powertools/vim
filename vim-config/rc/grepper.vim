runtime plugin/grepper.vim

fun! g:GrepperColors()
    highlight GrepperSideFile ctermfg=161 cterm=reverse
    highlight Conceal ctermfg=1 ctermbg=NONE
    highlight ErrorMsg ctermfg=160 ctermbg=NONE cterm=NONE"" Status bar
endf
call g:GrepperColors()

" let g:grepper.git.grepprg .= 'i'
" let g:grepper.<tool>.grepprg = ''

" TODO: change back?

let g:grepper.highlight = 1
let g:grepper.prompt_quote = 2
let g:grepper.append = 1 " -noappend AND cexpr [] are very versatile and no info gets lost

  " 0    No quote 1    Quote the query automatically.  2    Populate the prompt with single quotes and put cursor in between.  3    Populate the prompt with double quotes and put cursor in between.
" let g:grepper.append = 0
let g:grepper.tools = ['rg', 'git', 'grep']

let g:grepper.side = 0
nnoremap <F11>gside :let g:grepper.side = ! g:grepper.side <bar> echo 'g:grepper.side toggled to: '.g:grepper.side<CR>

" GrepperOperator: !!!
" `g:grepper.operator` can be used to configure the behaviour of the operator.
" `g:grepper.operator` takes exactly the same |grepper-options|.
nmap gr  <plug>(GrepperOperator)
xmap gr  <plug>(GrepperOperator)


" let g:grepper.tools = ['rg', 'git', 'grep'] " basics...
" ripgrep variations

let g:grepper.tools += ['rgpy', 'rgfpy']

let g:rg_nvcs = '--no-ignore-vcs'
let g:rg_hidden = '--hidden'

let g:rg_base = 'rg -H --no-heading --vimgrep'
let g:rg_grepformat = '%f:%l:%c:%m'
let g:rg_escape = '\^$.*+?()[]{}|'

fun! g:MakeRgtool(globs, flags)
    let l:result = g:rg_base . ' '
    for li in a:globs
        let l:result = l:result . "--iglob '" . li . "' "
    endfor
    for li in a:flags
        let l:result = l:result . li . ' '
    endfor
    return {
        \ 'grepprg':    l:result,
        \ 'grepformat': g:rg_grepformat,
        \ 'escape':     g:rg_escape,
        \  }
endf

fun! g:RipgrepFoursome(name, ...)
    let a:globpatterns = get(a:, 1, []) " must be a list of glob patterns
    " let l:patterns = []
    " if l:patternsArg != '<unset>'
    "     for pat in l:patternsArg
    "         call add(l:patterns, pat)
    "     endfor
    " endif
    let l:rg_ni =       ['rg'.a:name.'ni',    g:MakeRgtool(a:globpatterns,        [g:rg_nvcs])]
    let l:rg_f =        ['rg'.a:name.'f',     g:MakeRgtool(a:globpatterns,        ['-F'])]
    let l:rg_fni =      ['rg'.a:name.'fni',   g:MakeRgtool(a:globpatterns,        ['-F', g:rg_nvcs])]
    let l:rg_vanilla =  ['rg'.a:name,         g:MakeRgtool(a:globpatterns,        [])]
    return [l:rg_ni, l:rg_f, l:rg_fni, l:rg_vanilla]
    
endf

fun! g:AddGrepperSpec(grepper, ...)
    let l:grepperNamespace = get(a:, 1, 'g:grepper')

    call add(g:grepper.tools, a:grepper[0])
    let g:currentTool = a:grepper[1]   " TODO: can this be donce using a local variable? and 'less dynamic' entry below?
    exec 'let ' . l:grepperNamespace.'.' . a:grepper[0] . ' = g:currentTool'
endf

" tools: [name, config]
fun! g:SetRipgrepTools(dyntools, ...)
    let l:basetools = get(a:, 1, g:RipgrepFoursome(''))
    let l:grepperNamespace = get(a:, 2, 'g:grepper')

    let g:grepper.tools = []
    for entry in (a:dyntools + l:basetools)
        call g:AddGrepperSpec(entry, l:grepperNamespace)
    endfor
endf

let g:rg_pythontools = g:RipgrepFoursome('py', ['*.py'])
let g:rg_vimtools = g:RipgrepFoursome('vim', ['*.vim'])
call g:SetRipgrepTools([])
" TODO: operator variable space assignment can be done through optional argument, but left out for now

augroup pygrep
    autocmd FileType python call g:SetRipgrepTools(g:rg_pythontools)
augroup end
augroup vim_grep
    autocmd FileType vim call g:SetRipgrepTools(g:rg_vimtools)
augroup end


" Examples:
"   Customize_Command:
    " " initialize g:grepper with defaults
    " runtime plugin/grepper.vim

    " let g:grepper.tools += ['git']
    " let g:grepper.git = {
    "     \ 'grepprg':    'git grep -nI',
    "     \ 'grepformat': '%f:%l:%m',
    "     \ 'escape':     '\^$.*[]',
    "     \ }
" or
    " runtime plugin/grepper.vim
    " let g:grepper.rg.grepprg .= ' --smart-case'

    " Sidewindow:
    augroup grepper
        autocmd FileType GrepperSide let g:dummy=1
                    \| call g:GrepperColors()
                    \| nmap <buffer> <silent> ]] :let g:resetsr=getreg(g:defaultreg)<cr>/>>><CR>n:setreg(g:defaultreg, g:resetsr)<CR>
                    \| nmap <buffer> [[ />>><CR>N
        "  " this is very nice but messes up line-start anchored patterns
        "   \  silent execute 'keeppatterns v#'.b:grepper_side.'#>'
        "   \| silent normal! ggn
    augroup end

    " Custom_commands:
" command! Todo :Grepper -tool git -query '\(TODO\|FIXME\)'
" command! Todo :Grepper -noprompt -tool git -grepprg git grep -nIi '\(TODO\|FIXME\)'
    " If you find that hard to read, you can use multiple lines like this:
" command! Todo :Grepper
"       \ -noprompt
"       \ -tool git
"       \ -grepprg git grep -nIi '\(TODO\|FIXME\)'
