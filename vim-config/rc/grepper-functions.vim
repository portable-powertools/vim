let g:rg_escape_default = '\^$.*+?()[]{}|'

fun! g:MakeRgtool(globs, flags)
    let l:result = g:rg_base . ' '
    for li in a:globs
        let l:result = l:result . "--iglob '" . li . "' "
    endfor
    for li in a:flags
        let l:result = l:result . li . ' '
    endfor
    let escpattern = g:rg_escape_default
    " let g:rg_escape_default = '\^$.*+?()[]{}|'
    if index(a:flags, '-F') != -1
        let escpattern = '\'
    endif
    return {
        \ 'grepprg':    l:result,
        \ 'grepformat': g:rg_grepformat,
        \ 'escape':     escpattern,
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
    let result=[]
    call add(result, ['rg'.a:name,         g:MakeRgtool(a:globpatterns,        [])])
    call add(result, ['rg'.a:name.'f',     g:MakeRgtool(a:globpatterns,        ['-F'])])
    call add(result, ['rg'.a:name.'ni',    g:MakeRgtool(a:globpatterns,        [g:rg_nvcs])])
    call add(result, ['rg'.a:name.'fni',   g:MakeRgtool(a:globpatterns,        ['-F', g:rg_nvcs])])
    call add(result, ['rg'.a:name.'sym',    g:MakeRgtool(a:globpatterns,       ['--follow'])])
    return result
    
endf

fun! g:AddGrepperSpec(grepper, ...)
    let l:grepperNamespace = get(a:, 1, 'g:grepper')

    exec 'call add('.l:grepperNamespace.'.tools, a:grepper[0])'
    let g:currentTool = a:grepper[1]   " TODO: can this be donce using a local variable? and 'less dynamic' entry below?
    exec 'let ' . l:grepperNamespace.'.' . a:grepper[0] . ' = g:currentTool'
endf

" tools: [name, config]
fun! g:SetRipgrepTools(dyntools)
    let l:grepperNamespace = get(a:, 2, 'g:grepper')

    let g:grepper.tools = []
    for entry in (a:dyntools)
        call g:AddGrepperSpec(entry, l:grepperNamespace)
    endfor
endf
