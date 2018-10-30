let g:vimcfgdir = expand('<sfile>:p:h')

function! VimRcFile(basename)
    return g:vimcfgdir . "/" . a:basename
endfunction
function! Src(basename)
    exec "source " . VimRcFile(a:basename)
endfunction

call Src('config-support-funcs.vim')
call Src('config-default.vim')

" ====== make vim portable by overwriting the predefined runtimepath

let &runtimepath = printf('%s,%s,%s/vimfiles,%s,%s/vimfiles/after,%s/after,%s/after', g:adhocrtp, g:vimcfgdir, $VIM, $VIMRUNTIME, $VIM, g:vimcfgdir, g:adhocrtp)
