let g:bookmarksLocalIfPossible = 1
let g:bookmarksCfgName = '.bookmarks'

" Bookmarks
let g:bookmark_no_default_key_mappings = 1
nmap <Leader>mm <Plug>BookmarkToggle
nmap <Leader>mi <Plug>BookmarkAnnotate
nmap <Leader>m; <Plug>BookmarkShowAll
nmap <Leader>mj <Plug>BookmarkNext
nmap <Leader>mk <Plug>BookmarkPrev
nmap <Leader>mc <Plug>BookmarkClear
nmap <Leader>mx <Plug>BookmarkClearAll
nmap <Leader>mg <Plug>BookmarkMoveToLine

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
