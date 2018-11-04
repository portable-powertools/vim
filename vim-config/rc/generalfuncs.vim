
function! InputChar()
    let c = getchar()
    return type(c) == type(0) ? nr2char(c) : c
endfunction

fun! g:FlashLine(linenr, ...) abort
    let l:times = get(a:, 1, 1)
    let l:duration = get(a:, 2, 200)
    let l:lastcol = col([a:linenr, "$"])
    call call('g:FlashVisual', [[0, a:linenr, 1, 0], [0, a:linenr, l:lastcol, 0]]+a:000)
endf
fun! g:FlashVisual(pos1, pos2, ...) abort
    let l:times = get(a:, 1, 1)
    let l:duration = get(a:, 2, 200)
    let l:gvpos = g:GetVisualPos()
    let l:curpos = getcurpos()
    call PLLog('sdfsdf' . string(a:pos1) . string(a:pos2) . '$$$' . l:times . l:duration)
    
    call PLLog('gonna flash visually ' . string([a:pos1, a:pos2]))
    call call('g:SetVisualPos', [a:pos1, a:pos2])
    for i in range(l:times)
        if i > 0
            exec "sleep ".(l:duration/3)."m"
        endif
        keepj normal gv
        redraw
        exec "sleep ".l:duration."m"
        keepj normal 
        redraw
    endfor
    call call('g:SetVisualPos', l:gvpos)
    call setpos(".", l:curpos)
endf
fun! g:FlashMarkerRange(m1, m2, ...)
    let p1 = getpos(a:m1)
    let p2 = getpos(a:m2)
    call call('FlashVisual', [p1, p2] + a:000)
endf

" mapping fun
fun! g:IdxSet(list, idx, newVal) abort
    let l:new = copy(a:list)
    let l:new[a:idx] = a:newVal
    return l:new
endf

fun! g:GetVisualPos() abort
    return [getpos("'<"), getpos("'>")]
endf
fun! g:SetVisualPos(pos1, pos2, ...) abort
    let a:doReselect = get(a:, 1, 0)
    call setpos("'<", a:pos1)
    call setpos("'>", a:pos2)
    if a:doReselect
        exec "normal gv"
    endif
endf

fun! g:CleanColFromPattern(prevPattern) abort
    let l:cleaned = substitute(a:prevPattern, '\V\^\\%>\[0-9]\+c', '', '')
    return l:cleaned 
endf

fun! g:WithVar(varname, newvalexpr, fwdcmd) abort
    if exists(a:varname)
        let l:prevVal = eval(a:varname)
    endif
    exe 'let '.a:varname.' = '.a:newvalexpr
    try
        exe a:fwdcmd
    finally
        if exists('l:prevVal')
            exe 'let '.a:varname.' = '.string(l:prevVal)
        else
            exe 'unlet '.a:varname
        endif
    endtry
endf

" These functions will not work as intended in the presence of multibyte
" characters.

fun! ExpandVisualBefore(by_lines, by_cols)
  let [start_buf, start_line, start_col, start_off] = getpos("'<")
  let end_pos                                       = getpos("'>")
  if start_off != 0
    throw 'function ExpandVisualBefore(): ''virtualedit'' is not supported'
  endif
  " Note: “:help getpos()” says that the column of '< should be 0 when in
  " visual-line mode, but my tests indicate that it is set to 1 instead.
  " the column of '> should be set to a “large number”, which my tests confirm.
  if end_pos[2] >= 2147483647 && a:by_cols != 0
    echohl WarningMsg
    echo 'function ExpandVisualBefore(): cannot add or remove columns in visual-line mode'
    echohl None
  endif
  if setpos("'<", [start_buf, start_line-a:by_lines, start_col-a:by_cols, 0]) == -1
    throw 'function ExpandVisualBefore(): setpos() failed'
  endif
  " Note: For some obscure reason, when the cursor is at the start of the
  " selection, changing '< apparently sets '> to the former value of '<. Below,
  " we fix that by restoring '> to its initial value.
  " Under the same circumstances, the cursor is moved to the end of the
  " selection, we should fix that as well…
  if setpos("'>", end_pos) == -1
    throw 'function ExpandVisualAfter(): setpos() failed'
  endif
endfun

fun! ExpandVisualAfter(by_lines, by_cols)
  let start_pos                             = getpos("'<")
  let [end_buf, end_line, end_col, end_off] = getpos("'>")
  if end_off != 0
    throw 'function ExpandVisualAfter(): ''virtualedit'' is not supported'
  endif
  if end_col >= 2147483647 && a:by_cols != 0
    echohl WarningMsg
    echo 'function ExpandVisualAfter(): cannot add or remove columns in visual-line mode'
    echohl None
  endif
  if setpos("'>", [end_buf, end_line+a:by_lines, end_col+a:by_cols, 0]) == -1
    throw 'function ExpandVisualAfter(): setpos() failed'
  endif
  " Note: For some obscure reason, when the cursor is at the start of the
  " selection, changing '> apparently sets '< to the former value of '>. Below,
  " we fix that by restoring '< to its initial value.
  " Under the same circumstances, the cursor is moved to the end of the
  " selection, we should fix that as well…
  if setpos("'<", start_pos) == -1
    throw 'function ExpandVisualAfter(): setpos() failed'
  endif
endfun

vnoremap <silent> <F6>\- :call ExpandVisualBefore(0,-v:count1)<CR>gv
vnoremap <silent> <F6>\+ :call ExpandVisualBefore(0,v:count1)<CR>gv
vnoremap <silent> <F6>- :call ExpandVisualAfter(0,-v:count1)<CR>gv
vnoremap <silent> <F6>+ :call ExpandVisualAfter(0,v:count1)<CR>gv

fun! g:GVS()
    return g:Get_visual_selection()
endf
function! g:Get_visual_selection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

" Regex methods
fun! g:EscapeRegex(r)
    return "'" . substitute(a:r, "\\V'", "''", 'g') . "'"
endf
fun! g:UnEscapeRegex(r)
    return substitute(a:r, '\V''''', '''', 'g')
endf
fun! g:UnquoteEscapedRegex(r)
    return substitute(a:r, '\V\^''\(\.\*\)''\$', '\1', '')
endf

" Clipboard cleaning
fun! g:Stripreg(reg)
    call setreg(a:reg, trim(getreg(a:reg)))
endf

" for use in commands with <q-reg> as argument.
fun! g:Expandreg(...)
    let l:arg = get(a:, 1, '<unset>')
    
    if l:arg != '<unset>' && l:arg != ''
        return l:arg
    else
        return g:defaultreg
    endif
endf

" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
  let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
        \ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction


function! Mybadlogger(message, file)
  new
  setlocal buftype=nofile bufhidden=hide noswapfile nobuflisted
  put=a:message
  execute 'w >>' a:file
  q
endfun
