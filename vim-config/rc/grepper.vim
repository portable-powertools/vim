" TODO make it so that rg only lists one match per line

runtime plugin/grepper.vim

let g:grepper.open = 0
" autocmd User Grepper copen

"TODO: parse that into default motion options?
if !exists('g:defaultGrepperCmd')
    let g:defaultGrepperCmd = ['Grepper ', 9, ':']
endif
nmap <F10>g :<C-\>eg:RestoreCommandModeC(g:defaultGrepperCmd)<CR>
cmap <F10>g! <C-r>=[execute('let g:defaultGrepperCmd = g:CommandCurrent()'), ''][1]<CR>
cmap <F10>g0 <C-\>e[execute('let g:defaultGrepperCmd = ["Grepper ", 9, ":"]'), g:RestoreCommandModeC(g:defaultGrepperCmd)][1]<CR>
nmap <Leader><C-g> <C-g><CR>

cmap <F10>gb -buffer<Space>-noquickfix<Space>
cmap <F10>gB -buffers<Space>
cmap <F10>gs -side<Space>
cmap <F10>gS -noside<Space>
cmap <F10>gj -jump<Space>
cmap <F10>gJ -nojump<Space>
cmap <F10>gp -switch<Space>
cmap <F10>gP -noswitch<Space>
cmap <F10>ga -append<Space>
cmap <F10>gA -noappend<Space>
cmap <F10>gd -dir<Space><C-r>=expand('%:p:h')<CR><Space>
cmap <F10>gD -dir<Space><C-r>=getcwd(-1)<CR><Space>
cmap <F10>gq -noprompt -query<Space>
cmap <F10>gl -noquickfix<Space>
cmap <F10>gt -tool<Space>

cmap <F10>g<Tab> <Tab><Tab><Tab><Tab>


" TODO: figure out where such stuff really belongs and how to link it
" correctly. AFAIK this is for -side only?
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
  " 0    No quote 1    Quote the query automatically.  2    Populate the prompt with single quotes and put cursor in between.  3    Populate the prompt with double quotes and put cursor in between.
let g:grepper.prompt_quote = 2
let g:grepper.append = 0
let g:grepper.switch = 0
let g:grepper.jump = 0

let g:grepper.side = 0

" GrepperOperator: !!!
" `g:grepper.operator` can be used to configure the behaviour of the operator.
" `g:grepper.operator` takes exactly the same |grepper-options|.
nmap gr  <plug>(GrepperOperator)
xmap gr  <plug>(GrepperOperator)

let g:rg_nvcs = '--no-ignore-vcs'
let g:rg_hidden = '--hidden'

let g:rg_base = 'rg -H --no-heading --vimgrep'
let g:rg_grepformat = '%f:%l:%c:%m'

let g:rg_pythontools = g:RipgrepFoursome('py', ['*.py'])
let g:rg_vimtools = g:RipgrepFoursome('vim', ['*.vim'])
let g:rg_basetools = g:RipgrepFoursome('')

" let g:grepper.tools = ['rg', 'git', 'grep']
call g:SetRipgrepTools(g:rg_basetools + g:rg_pythontools + g:rg_vimtools)

" autocmd FileType python call g:SetRipgrepTools(g:rg_pythontools)
" autocmd FileType vim call g:SetRipgrepTools(g:rg_vimtools)

" TODO: operator ("rgia") variable space assignment can be done through optional argument, but left out for now

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
        au!
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
