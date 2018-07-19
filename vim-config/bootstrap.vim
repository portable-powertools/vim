" ====== make vim portable.

let &runtimepath = printf('%s/vimfiles,%s,%s/vimfiles/after', $VIM, $VIMRUNTIME, $VIM)
let g:vimcfgdir = expand('<sfile>:p:h')
let &runtimepath = printf('%s,%s,%s/after', g:vimcfgdir, &runtimepath, g:vimcfgdir)

command! -nargs=1 GoVimRc execute 'new '.VimRcFile(<f-args>)
function! VimRcFile(basename)
    return g:vimcfgdir . "/" . a:basename
endfunction
function! Src(basename)
    exec "source " . VimRcFile(a:basename)
endfunction
