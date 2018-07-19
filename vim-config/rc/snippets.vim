" Ultisnips
let g:UltiSnipsSnippetsDir=g:vimplugindir."/vim-snippets/custom/UltiSnips"
let g:UltiSnipsSnippetDirectories=["UltiSnips"]
let g:UltiSnipsEnableSnipMate = 1
let &runtimepath = printf('%s,%s', &runtimepath, g:UltiSnipsSnippetsDir . '/..')
