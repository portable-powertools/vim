" let g:ycm_log_level='debug'
let g:ycm_cache_omnifunc = 1
let g:ycm_min_num_of_chars_for_completion = 2
let g:ycm_auto_trigger = 1
let g:ycm_max_num_identifier_candidates = 40
let g:ycm_complete_in_comments = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_collect_identifiers_from_tags_files = 0 "They say this may be slow
let g:ycm_seed_identifiers_with_syntax = 1 "TODO: try out how this behaves

let g:ycm_filepath_completion_use_working_dir = 1 "filepath compl rel. to cwd or to file

" Preview window behavior
let g:ycm_autoclose_preview_window_after_completion = 0 " after popup
let g:ycm_autoclose_preview_window_after_insertion = 1 " after insert mode
let pumheight=18
nnoremap <F11>ycmi :let g:ycm_autoclose_preview_window_after_insertion = ! g:ycm_autoclose_preview_window_after_insertion <bar> echo 'g:ycm_autoclose_preview_window_after_insertion toggled to: '.g:ycm_autoclose_preview_window_after_insertion<CR>
nnoremap <F11>ycmc :let g:ycm_autoclose_preview_window_after_completion= ! g:ycm_autoclose_preview_window_after_completion <bar> echo 'g:ycm_autoclose_preview_window_after_completion toggled to: '.g:ycm_autoclose_preview_window_after_completion<CR>

" [ 'same-buffer', 'horizontal-split', 'vertical-split', 'new-tab', 'new-or-existing-tab' ] 
let g:ycm_goto_buffer_command = 'vertical-split' 

let g:ycm_key_invoke_completion = '<C-Space>' 
    " let g:ycm_key_detailed_diagnostics = '<leader>d' 
let g:ycm_key_list_stop_completion = ['<C-M>']
    " let g:ycm_key_list_stop_completion = ['<C-y>'] 
let g:ycm_key_list_select_completion = ['<Down>', '<C-j>']
let g:ycm_key_list_previous_completion = ['<Up>', '<C-k>'] 
    " inoremap <expr> <C-j> pumvisible() ? '<DOWN>' : '<C-j>'
    " inoremap <expr> <C-k> pumvisible() ? '<UP>' : '<C-k>' 
    " let g:ycm_key_list_select_completion = ['<TAB>', '<Down>']
    " let g:ycm_key_list_previous_completion = ['<S-TAB>', '<Up>'] 

nmap <Leader>y <F10>y
nnoremap <F10>yGG :YcmCompleter GoTo<CR>
nnoremap <F10>ygg :YcmCompleter GoToImprecise<CR>
nnoremap <F10>ygt :YcmCompleter GoToType<CR>

nnoremap <F10>ygd :YcmCompleter GoToDeclaration<CR>
nnoremap <F10>ygD :YcmCompleter GoToDefinition<CR>

nnoremap <F10>ygi :YcmCompleter GoToImplementationElseDeclaration<CR>
nnoremap <F10>ygI :YcmCompleter GoToImplementation<CR>


nnoremap <F10>yr :YcmCompleter GoToReferences<CR>

nnoremap <F10>yt :YcmCompleter GetTypeImprecise<CR>
nnoremap <F10>yT :YcmCompleter GetType<CR>

nnoremap <F10>yd :YcmCompleter GetDocImprecise<CR>
nnoremap <F10>yD :YcmCompleter GetDoc<CR>

nnoremap <F10>yfix :YcmCompleter FixIt<CR>
nnoremap <F10>yref :YcmCompleter RefactorRename<CR>



" Ultisnips:

" Trigger snippets retrieval: doautocmd FileType 
" The g:ycm_key_list_stop_completion option -- This option controls the key mappings used to close the completion menu. This is useful when the menu is blocking the view, when you need to insert the <TAB> character, or when you want to expand a snippet from UltiSnips and navigate through it.
" :h UltiSnips-triggers 

let g:UltiSnipsExpandTrigger='<tab>'
" let g:UltiSnipsListSnippets='<c-g>'
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<S-tab>'




" Artifacts:

" Functions 

" for seeing if autocompletion preview is open
" fun! PreviewWindowOpened()
"     for nr in range(1, winnr('$'))
"         if getwinvar(nr, "&pvw") == 1
"             " found a preview
"             return 1
"     endif
"     endfor
"     return 0
" endfun
" " toggle whether popups are autoclosed; closes the current popup.
" function! TogglePreviewPopups()
"   if(g:keepPopup)
"     execute 'pclose'
"   else

"   endif
"   let g:keepPopup = ! g:keepPopup
"   echo "autoclosing popups: ".g:keepPopup
" endfun
" let g:keepPopup = 1



" Popup:

"imap <expr> <C-m> pumvisible() ? '<C-y>' : '<C-m>' 
"imap <expr> <Space> pumvisible() ? '<C-[>i<Right>' : '<Space>' 
"imap <expr> ; pumvisible() ? '<C-[>:pclose<CR>' : ';' 

" Python:
" This may be an executable name for autonomous search or an absolute PATH.
" TODO make $HOME independent
" let g:ycm_python_binary_path = '/home/simon/.pyenv/versions/3.6.5/bin/python'
"
" probably never uncomment...
" let g:ycm_server_python_interpreter =  $HOME."/.pyenv/versions/2.7.14/bin/python"

" ==========

" let s:expansion_active = 0

" function! ycm#setup_mappings()
"   " Overwrite the mappings that UltiSnips sets up during expansion.
"   execute 'inoremap <buffer> <silent> ' . g:UltiSnipsJumpForwardTrigger .
"         \ ' <C-R>=ycm#expand_or_jump("N")<CR>'
"   execute 'snoremap <buffer> <silent> ' . g:UltiSnipsJumpForwardTrigger .
"         \ ' <Esc>:call ycm#expand_or_jump("N")<CR>'
"   execute 'inoremap <buffer> <silent> ' . g:UltiSnipsJumpBackwardTrigger .
"         \ ' <C-R>=ycm#expand_or_jump("P")<CR>'
"   execute 'snoremap <buffer> <silent> ' . g:UltiSnipsJumpBackwardTrigger .
"         \ ' <Esc>:call ycm#expand_or_jump("P")<CR>'

"   " One additional mapping of our own: accept completion with <CR>.
"   imap <expr> <buffer> <silent> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
"   smap <expr> <buffer> <silent> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

"   let s:expansion_active = 1
" endfunction

" function! ycm#teardown_mappings()
"   silent! iunmap <expr> <buffer> <CR>
"   silent! sunmap <expr> <buffer> <CR>

"   let s:expansion_active = 0
" endfunction

" let g:ulti_jump_backwards_res = 0
" let g:ulti_jump_forwards_res = 0
" let g:ulti_expand_res = 0

" function! ycm#expand_or_jump(direction)
"   call UltiSnips#ExpandSnippet()
"   if g:ulti_expand_res == 0
"     " No expansion occurred.
"     if pumvisible()
"       " Pop-up is visible, let's select the next (or previous) completion.
"       if a:direction == 'N'
"         return "\<C-N>"
"       else
"         return "\<C-P>"
"       endif
"     else
"       if s:expansion_active
"         if a:direction == 'N'
"           call UltiSnips#JumpForwards()
"           if g:ulti_jump_forwards_res == 0
"             " We did not jump forwards.
"             return "\<Tab>"
"           endif
"         else
"           call UltiSnips#JumpBackwards()
"         endif
"       else
"         if a:direction == 'N'
"           return "\<Tab>"
"         endif
"       endif
"     endif
"   endif

"   " No popup is visible, a snippet was expanded, or we jumped, or we failed to
"   " jump backwards, so nothing to do.
"   return ''
" endfunction
