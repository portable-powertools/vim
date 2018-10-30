"TODO: create code that hooks into dirvish and sources designated 'file
" browser' related files, e.g. '.dirvishrc' upon FileType. see legacy graspit
" data folder for how that would look like (autocommands partially useless!
" -> different from regular vimrc!).
" see also setting: g:localvimrc_event_pattern, but untested as of yet
" KEEP in mind that localvimrc was forked to allow dirvish updates to go
" through!

" let g:localvimrc_event = ['BufWinEnter', 'FileType', 'TabEnter']
let g:localvimrc_event = ['BufWinEnter', 'TabEnter']

let g:localvimrc_sandbox = 0
let g:localvimrc_ask = 1
let g:localvimrc_persistent = 1
let g:localvimrc_persistence_file = g:UnmanagedDataFile('localvimrcpersistence')

