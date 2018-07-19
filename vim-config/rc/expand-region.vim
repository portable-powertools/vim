" ========= expandregion

" " Default settings. (NOTE: Remove comments in dictionary before sourcing)
" let g:expand_region_text_objects = {
"       \ 'iw'  :0,
"       \ 'iW'  :0,
"       \ 'i"'  :0,
"       \ 'i''' :0,
"       \ 'i]'  :1, " Support nesting of square brackets
"       \ 'ib'  :1, " Support nesting of parentheses
"       \ 'iB'  :1, " Support nesting of braces
"       \ 'il'  :0, " 'inside line'. Available through https://github.com/kana/vim-textobj-line
"       \ 'ip'  :0,
"       \ 'ie'  :0, " 'entire file'. Available through https://github.com/kana/vim-textobj-entire
"       \ }

        " \ 'ie'  :0,
let g:expand_region_text_objects = {
        \ 'iw'  :0,
        \ 'iW'  :0,
        \ 'i"'  :0,
        \ 'i''' :0,
        \ 'i]'  :1,
        \ 'ib'  :1,
        \ 'iB'  :1,
        \ 'il'  :0,
        \ 'ip'  :1,
        \ 'a"' :0,
        \ 'a''' :0,
        \ 'a]' :1,
        \ 'ab' :1,
        \ 'aB' :1,
        \ 'ii' :0,
        \ 'ai' :0,
      \ }

" Extend the global default (NOTE: Remove comments in dictionary before sourcing)
            " " \ "\/\\n\\n\<CR>": 1,
" call expand_region#custom_text_objects({
            " \ '}' :1,
            " \ '{' :1,
            " \ 'a"' :1,
            " \ 'a''' :1,
            " \ 'a]' :1,
            " \ 'ab' :1,
            " \ 'aB' :1,
            " \ 'ii' :0,
            " \ 'ai' :0,
            " \ })

" You can further customize the text objects dictionary on a per filetype basis
" by defining global variables like 'g:expand_region_text_objects_{ft}'. >

" Use the following setting for ruby. (NOTE: Remove comments in dictionary  before sourcing)
" let g:expand_region_text_objects_ruby = {
"             \ 'im' :0, " 'inner method'. Available through https://github.com/vim-ruby/vim-ruby
"             \ 'am' :0, " 'around method'. Available through https://github.com/vim-ruby/vim-ruby
"             \ }

" Note that this completely replaces the default dictionary. To extend the
" default on a per filetype basis, you can call
" 'expand_region#custom_text_objects' by passing in the filetype in the first
" argument: >

" Use the global default + the following for ruby
" call expand_region#custom_text_objects('ruby', {
"             \ 'im' :0,
"             \ 'am' :0,
"             \ })
