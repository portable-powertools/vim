let g:bookmarksLocalIfPossible = 1
let g:bookmarksCfgName = '.bookmarks'

" Bookmarks
let g:bookmark_no_default_key_mappings = 1
nmap <F10>mm <Plug>BookmarkToggle
nmap <F10>mi <Plug>BookmarkAnnotate
nmap <F10>m; <Plug>BookmarkShowAll
nmap <F10>mj <Plug>BookmarkNext
nmap <F10>mk <Plug>BookmarkPrev
nmap <F10>mc <Plug>BookmarkClear
nmap <F10>mx <Plug>BookmarkClearAll
nmap <F10>mg <Plug>BookmarkMoveToLine

let g:bookmark_center = 1

" Mutually exclusive, should both work, TODO retest commented version though
" let g:bookmark_manage_per_buffer = 1
let g:bookmark_save_per_working_dir = 1

let g:bookmark_auto_save = 1
let g:bookmark_auto_save_file = g:UnmanagedDataFileForCwd(g:bookmarksCfgName.'_autosave', 0)
let g:bookmark_highlight_lines = 1

function! g:BMWorkDirFileLocation()
    return g:UnmanagedDataFileForCwd(g:bookmarksCfgName, g:bookmarksLocalIfPossible)
endfunction
" Finds the Git super-project directory based on the file passed as an argument.
function! g:BMBufferFileLocation(file)
    return g:UnmanagedDataFileForSingle(a:file, g:bookmarksCfgName, g:bookmarksLocalIfPossible)
endfunction
