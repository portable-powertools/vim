" returns empty string, or the parent dir containing either .git repo or (precedence) the Marker .projectroot
" additional parameter is a list. For now we assume it is ['.projectroot']
" TODO: implement varargs project markers
function! g:FindGitOrProjectroot(startingpoint, ...)
    let l:locGit = finddir('.git', a:startingpoint.';')
    let l:locMarker = findfile('.projectroot', a:startingpoint.';')
    let l:localBase = ''
    if len(l:locGit) > 0
        let l:localBase = fnamemodify(l:locGit, ':p:h:h')
    endif
    " Marker takes precedence
    if len(locMarker) > 0
        let l:localBase = fnamemodify(l:locMarker, ':p:h')
    endif
    return l:localBase
endfunction

fun! g:EnvvarLikeInShell(name)
    let l:expanded = expand('$'.a:name)
    if l:expanded ==# '$'.a:name
        return ''
    else
        return l:expanded
    endif
endf
fun! g:EnvVarBool(varname)
    let l:val = g:EnvvarLikeInShell(a:varname)
    if ( len(l:val) == 0 || l:val == '0' )
        return 0
    endif
    return 1
endf

" Config three-hop: preconfig by modal init, env var or default with optional warning.
" vimname must be without the global 'g:'
fun! g:ConfigVal(vimname, envname, default, warn)
    if exists(a:vimname) && ! empty(get(g:, a:vimname, ''))
        return get(g:, a:vimname, '')
    else
        if ! empty(a:envname) && ! empty(g:EnvvarLikeInShell(a:envname))
            return g:EnvvarLikeInShell(a:envname)
        else
            if a:warn
                echohl 'using default for vim setting '.a:vimname.': '.a:default
            endif
            return a:default
        endif
    endif
endf

" Plug conditional loading
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction


fun! g:IsLocalConfAllowed()
    return ! g:forceGlobalPluginBehavior
endf

" startingpoint is a file relative to the local context, let's use getcwd() where possible
" dirSuffix should be '/subdir', or empty if the dir to be used shall be the global base config dir, or directly the root of the local context
" localIfPossible is boolean (0 or 1) and specifies the preference to use a local context
" Thisfunction then tries to dtermine the local context and use if it preferred and possible, else it uses the globalone..
fun! g:UnmanagedDataDirectoryProxy(startingpoint, dirSuffix, localIfPossible)
    let l:defaultConf = g:vimunmanageddir
    let l:globalVersion = l:defaultConf.a:dirSuffix
    let l:localVersion = g:FindGitOrProjectroot(a:startingpoint)
    if len(l:localVersion) > 0
        if a:localIfPossible && g:IsLocalConfAllowed()
            return l:localVersion
        endif
    endif
    return l:globalVersion
endf

fun! g:UnmanagedDataFileProxy(filename, startingpoint, dirSuffix, localIfPossible)
    return g:UnmanagedDataDirectoryProxy(a:startingpoint, a:dirSuffix, a:localIfPossible).'/'.a:filename
endf

" just-global-config data file
fun! g:UnmanagedDataFile(objName)
    return g:UnmanagedDataFileProxy(a:objName.'.config', '.', '', 0)
endf
fun! g:UnmanagedDataFolder(objName)
    return g:UnmanagedDataFileProxy(a:objName, '.', '', 0)
endf
" may be local based on CWD
fun! g:UnmanagedDataFileForCwd(objName, localIfPossible)
    return g:UnmanagedDataFileProxy(a:objName.'.config', getcwd(), '', a:localIfPossible)
endf
fun! g:UnmanagedDataFolderForCwd(objName, localIfPossible)
    return g:UnmanagedDataFileProxy(a:objName, getcwd(), '', a:localIfPossible)
endf
fun! g:UnmanagedDataFileForSingle(localFile, objName, localIfPossible)
    return g:UnmanagedDataFileProxy(a:objName, a:localFile, '', a:localIfPossible)
endf
