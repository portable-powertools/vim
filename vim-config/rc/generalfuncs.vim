let s:k_script_name = expand('<sfile>:p')
let s:verbose = get(s:, 'verbose', 0)
function! GFVerbose(...)
  if a:0 > 0
    let s:verbose = a:1
  endif
  return s:verbose
endfunction
function! s:Log(...)
  call call('lh#log#this', a:000)
endfunction
function! s:Verbose(...)
  if s:verbose
    call call('s:Log', a:000)
  endif
endfunction

""""""""""""""""""""""""
"  assorted functions  "
""""""""""""""""""""""""


function! OutputSplitWindow(...)
  " this function output the result of the Ex command into a split scratch buffer
  let cmd = join(a:000, ' ')
  let temp_reg = @"
  redir @"
  silent! execute cmd
  redir END
  let output = copy(@")
  let @" = temp_reg
  if empty(output)
    echoerr "no output"
  else
    new
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
    put! =output
  endif
endfunction
command! -nargs=+ -complete=command Redibuf call OutputSplitWindow(<f-args>)

fun! GetStack(handle) abort
    if ! has_key(g:stacks, a:handle)
        let g:stacks[a:handle] = lh#stack#new()
    endif
    return g:stacks[a:handle]
endf
if ! exists('g:stacks')
    let g:stacks = {}
endif

fun! LHStr(...) abort
    if a:0 == 0
        return ''
    endif
    if a:0 == 1
        return lh#object#to_string(a:1)
    endif
    return lh#object#to_string(a:000)
endf

fun! Nop(...) abort
endf

fun! g:GetEMLineNr() abort
" retval == 0 -> success
" retval == 1 -> cancelled
" see snippet emline
    call inputsave()
    let prev = getpos('.')
    let retval = EasyMotion#Sol(0, '2')
    let retpos = getpos('.')
    call setpos('.', prev)
    call inputrestore()
    return [retval, retpos[1]]
endf

function! InputChar()
    let c = getchar()
    return type(c) == type(0) ? nr2char(c) : c
endfunction

fun! g:FlashLines(linenr1, linenr2, ...) abort
    let selection = MakeVisPos(a:linenr1, a:linenr2)
    call s:Log('FlashLines args: %1',  string([a:linenr1, a:linenr2]+a:000))
    call s:Log('FlashLines args passed: %1',  selection+a:000)
    call call('g:FlashVisual', selection+a:000)
endf
fun! g:FlashLine(linenr1, ...) abort
    call call('g:FlashLines', [a:linenr1, a:linenr1] + a:000)
endf
fun! g:FlashCurrentLine(...) abort
    call call('g:FlashLine', [line('.')] + a:000)
endf
fun! g:FlashVisual(pos1, pos2, ...) abort
    call s:Log('FlashVis args: %1',  string([a:pos1, a:pos2]+a:000))
    
    let l:times = get(a:, 1, 1)
    let l:duration = get(a:, 2, 200)
    let l:gvpos = g:GetVisualPos()
    let l:curpos = getcurpos()
    
    call s:Verbose('gonna flash visually ' . string([a:pos1, a:pos2]))
    for i in range(l:times)
        if i > 0
            exec "sleep ".(l:duration/3)."m"
        endif
        call g:SetVisualPos([a:pos1, a:pos2], 1)
        redraw
        exec "sleep ".l:duration."m"
        keepj normal 
        redraw
    endfor
    call g:SetVisualPos(l:gvpos)
    call setpos(".", l:curpos)
endf
fun! g:FlashMarkerRange(m1, m2, ...)
    let p1 = getpos("'".a:m1)
    let p2 = getpos("'".a:m2)
    call call('FlashLines', [p1[1], p2[1]] + a:000)
endf

fun! g:IdxSet(list, idx, newVal) abort
    let l:new = copy(a:list)
    let l:new[a:idx] = a:newVal
    return l:new
endf

fun! g:GetVisualPos() abort
    return [getpos("'<"), getpos("'>")]
endf
fun! g:SetVisualPos(posArray, ...) abort
    let [a:pos1, a:pos2] = a:posArray
    let a:doReselect = get(a:, 1, 0)
    call setpos("'<", a:pos1)
    call setpos("'>", a:pos2)
    let apparentMode = g:ApparentVisMode(a:posArray)
    call s:Verbose('apparentmode '. apparentMode . ' for ' . string(a:posArray) . ', reselect=' . a:doReselect)
    let vmode = visualmode()
    if vmode !=# apparentMode
        let lazyrd_old = &lazyredraw
        let &lazyredraw = 1
        let savepos = getpos('.')
        keepj normal gv
        call s:Verbose('switching mode to ' . apparentMode . ' from '. vmode )
        call feedkeys(apparentMode)
        call feedkeys('', 'x')
        call setpos('.', savepos)
        let &lazyredraw = lazyrd_old
    endif
    if a:doReselect == 1
        normal gv
        let vmode = mode()
        call s:Verbose('vmode = ' . vmode)
        if vmode !=# apparentMode
            call s:Verbose('switching mode to ' . apparentMode . ' from '. vmode )
            call feedkeys(apparentMode)
        endif
        " call feedkeys("\<Esc>")
    endif
endf
fun! g:ApparentVisMode(posArray)
    if a:posArray[1][2] == 2147483647 && a:posArray[0][2] != 1
        call s:Log('ApparentVisMode: inconsistency in posArray '.string(posArray).'. ApparentVisMode ' . string(a:posArray))
    endif
    let apparent = a:posArray[1][2] == 2147483647 && a:posArray[0][2] == 1 ? 'V' : 'v'
    return apparent
endf
fun! g:AdaptVisPos(visPosPairArray)
    return g:MakeVisPos(a:visPosPairArray[0][1], a:visPosPairArray[1][1], a:visPosPairArray[0][2], a:visPosPairArray[1][2])
endf
fun! g:MakeVisPos(line1, line2, ...)
    let a:col1 = get(a:, 1, 1)
    let a:col2 = get(a:, 2, 2147483647)
    " let a:apparentMode = get(a:, 3, a:col2 == 2147483647 && a:col1 == 1 ? 'V' : 'v')
    let a:apparentMode = get(a:, 3, a:col2 == 2147483647 && a:col1 == 1 ? 'V' : 'v')

    " sanity checks
    if a:line1 < 1
        call s:Verbose('makeVisPos: a:line1 was requested less than 1; will be reset to 1' . a:line1)
        let a:line1 = 1
    endif
    if a:line2 < 1
        let a:line2 = 1
        call s:Verbose('makeVisPos: a:line1 was requested less than 1; will be reset to 1' . a:line1)
    endif
    if a:line1 > line('$')
        call s:Verbose('makeVisPos: a:line1 was requested to be greater than the current max line' . a:line1)
    endif
    if a:line2 > line('$')
        call s:Verbose('makeVisPos: a:line2 was requested to be greater than the current max line: ' . a:line2)
    endif
    if a:col1 < 1
        call s:Verbose('makeVisPos: a:col1 was requested less than 1; will be reset to 1: ' . a:col1)
        let a:col1 = 1
    endif
    if a:col2 < 1
        call s:Verbose('makeVisPos: a:col2 was requested less than 1; will be reset to 1: '. a:col2)
        let a:col1 = 1
    endif
    if a:col1 > col([a:line1, '$']) && a:col1 != 2147483647
        call s:Verbose('makeVisPos: a:col1 was requested to be greater than the current max col: '. a:col1 .'; !!will be reset to 1 (only col2 may do that currently)')
        let a:col1 = 1
    endif
    if a:col2 > col([a:line2, '$']) && a:col2 != 2147483647
        call s:Verbose('makeVisPos: a:col2 was requested to be greater than the current max col: '. a:col2)
    endif
    if a:apparentMode ==# 'V'
        " V is selected only when the parameters strictly match see above
        return [[0, a:line1, 1, 0], [0, a:line2, 2147483647, 0]]
    else
        " here would be wiggle room and mayne a mode overriding param e.g. when col1 was specified != 1 but not col2
        " currently we count this case as character mode
        return [[0, a:line1, a:col1, 0], [0, a:line2, a:col2, 0]]
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

fun! ExpandVisualBefore(by_lines, by_cols)
" vnoremap <silent> <F6>\- :call ExpandVisualBefore(0,-v:count1)<CR>gv
" vnoremap <silent> <F6>\+ :call ExpandVisualBefore(0,v:count1)<CR>gv
" vnoremap <silent> <F6>- :call ExpandVisualAfter(0,-v:count1)<CR>gv
" vnoremap <silent> <F6>+ :call ExpandVisualAfter(0,v:count1)<CR>gv
" These functions will not work as intended in the presence of multibyte
" characters.
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

fun! g:GVS(...)
" optional parameter tells us whether to include a dangling CR when selected (1: yes, 0:no)
    return call('g:Get_visual_selection', [] + a:000)
endf
function! g:Get_visual_selection(...)
    let a:includeFinalCR = get(a:, 1, 1)
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    let result = join(lines, "\n")
    if column_end >= col([line_end, '$']) && a:includeFinalCR
        let result = result . "\n"
    endif
    return result 
endfunction

fun! g:EscapeRegex(r)
    return "'" . substitute(a:r, "\\V'", "''", 'g') . "'"
endf
fun! g:UnEscapeRegex(r)
    return substitute(a:r, '\V''''', '''', 'g')
endf
fun! g:UnquoteEscapedRegex(r)
    return substitute(a:r, '\V\^''\(\.\*\)''\$', '\1', '')
endf
fun! g:Stripreg(reg)
    call setreg(a:reg, trim(getreg(a:reg)))
endf
fun! g:Expandreg(...)
" for use in commands with <q-reg> as argument.
    let l:arg = get(a:, 1, '<unset>')
    
    if l:arg != '<unset>' && l:arg != ''
        return l:arg
    else
        return g:defaultreg
    endif
endf

function! AppendModeline()
" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
  let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
        \ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction

""""""""""""""""""""""""""""""""
"  something sophisticated...  "
""""""""""""""""""""""""""""""""

function! GetPresentOperatorData(...) dict abort
    "TODO: sanity check arguments
    return OperatorData(call('ParseOpfunData', a:000))
endfunction

" TODO: clean; make this more conform to the transaction / call args centric
" view established in StM
function! OperatorData(asList) abort
let s = lh#object#make_top_type({
        \ '_asList': a:asList, 
        \ 'content': a:asList[0], 
        \ 'posrange': a:asList[1], 
        \ 'markerrange': a:asList[2], 
        \ 'type': a:asList[3], 
        \ 'distantpos': a:asList[4]
        \ })
    return s
endfunction

fun! ParseOpfunData(type) abort
" returns [stringcontent, [[pos1x4],[pos2x4]], [mark1Str, mark2Str], a:type, [distantPos1x4, distantPosIdx(0 or 1 <> '<, '>)]] // type=visual/line/whatever a:type contains
    "type can be line, char, block, visual" -- with visual, gv get us the right selection. user can then check for trailing newline herself...

    if a:type == 'visual'
        let evalpos = g:GetVisualPos()
        let signs = ["'<","'>"]
        let l:content = g:Get_visual_selection(1)
    else
        let vispos = g:GetVisualPos()
        let pos = getpos(".")

        if a:type == 'line'
            silent keepj exe "normal! '[V']"
        else
            silent keepj exe "normal! `[v`]"
        endif
        let evalpos = g:GetVisualPos()
        let signs = ["'[","']"]
        silent keepj norm 
        let l:content = g:Get_visual_selection(1)

        keepj call g:SetVisualPos(vispos)
        keepj call setpos(".", pos)
    endif
    
    let [p1, p2] = evalpos
    let distantpos = p2
    let distantidx = 1
    let curpos = getpos('.')
    let distantpos = p2
    let distantidx = 1
    if abs(p1[1]-curpos[1]) > abs(p1[1]-curpos[1]) || abs(p1[2]-curpos[2]) > abs(p2[2]-curpos[2])
        let distantpos = p1
        let distantidx = 0
    endif
    return [l:content, evalpos, signs, a:type, [distantpos, distantidx]]
endf

fun! g:CaptureDeletion(...) abort
" default arg is the current vis selection
" returns a Deletion object
" if specified as list, length of 4 or 5 indicates single pos like pos(..) returns
"                           -- the members need all not be also lists
"                       length of 2 where the members are not lists, indicates [linenr, colnr] 
"                       length of 2 where the members are also lists indicates a range like [pos(...), pos(...)]
" if specified as a string, the argument is fed to pos(), i.e. '.', "'z", ...
" if specified as a int, the argument is taken as the column in the current line
" =====
" returns [parsed_spec(2x4 pos(..) format), projectedcurpos, startpos==endpos]
        let spec = get(a:, 1, g:GetVisualPos())
        if type(spec) == 3
            let memberlists = type(spec[0]) == 3
            if memberlists
                call assert_true(len(spec) == 2)
                let parsedspec = spec
            else
                if len(spec) == 2
                    let parsedspec = [[0]+spec[0]+[0], [0]+spec[1]+[0]]
                elseif len(spec) == 4 or len(spec) == 5
                    let parsedspec = [spec[0:3], spec[0:3]]
                else 
                    throw "ProjectPosDelete: not a valid spec: ".string(spec)
                endif
            endif
        elseif type(spec) == 1
            let pos = getpos(spec)
            let parsedspec = [pos, pos]
        elseif type(spec) == 0
            let pos = [0, line('.'), spec, 0]
            let parsedspec = [pos, pos]
        endif

        let [startpos, endpos] = parsedspec
        let startline = startpos[1]
        let endline = endpos[1]
        let startlineEnd = col([startline, '$'])
        let endlineEnd = col([endline, '$']) 
        let startcol = min([col([startline, '$']), startpos[2]])
        let endcol = min([col([endline, '$']), endpos[2]])
        let nextlineChars = strchars(getline(endline+1))

        " Pushback of the START of the selection, imminent because end of line selected
        let charsLeftAtEOL = endcol < endlineEnd -1 " CR may not be included!
        let pushbackImminent = ! charsLeftAtEOL
        let atCR = endlineEnd <= endcol " will delete the \n
        
        return Deletion(parsedspec, startpos, endpos, startline, endline, startlineEnd, endlineEnd, startcol, endcol, nextlineChars, charsLeftAtEOL, pushbackImminent, atCR)
endf

function! Deletion(capturedRange, startpos, endpos, startline, endline, startlineEnd, endlineEnd, startcol, endcol, nextlineChars, charsLeftAtEol, pushbackImminent, atCR) abort
let s = lh#object#make_top_type({
        \ 'capturedRange': a:capturedRange, 
        \ 'startpos': a:startpos, 
        \ 'endpos': a:endpos, 
        \ 'startline': a:startline, 
        \ 'endline': a:endline, 
        \ 'startlineEnd': a:startlineEnd, 
        \ 'endlineEnd': a:endlineEnd, 
        \ 'startcol': a:startcol, 
        \ 'endcol': a:endcol, 
        \ 'nextlineChars': a:nextlineChars, 
        \ 'charsLeftAtEol': a:charsLeftAtEol, 
        \ 'pushbackImminent': a:pushbackImminent, 
        \ 'atCR': a:atCR
        \ })

    function! s.willFeed() dict abort
        return (self.atCR && self.nextlineChars > 0)
    endfunction

    function! s.posAfter() dict abort

        if self.pushbackImminent
            if self.willFeed()
                let resultcol = self.startcol " wont be pushed back because something will feed the line
            else
                if self.startcol == 1 " cant be pushed back
                    let resultcol = self.startcol
                else
                    let resultcol = self.startcol-1
                endif
            endif
        else
            let resultcol = self.startcol
        endif
        let resultline = self.startline
        return [0, resultline, resultcol, 0]
    endfunction

    function! s.whichPasteThen() dict abort
        let projection = self.posAfter()
        echom string(projection)
        echom self.startcol
        if self.startcol == projection[2]
            return 'P'
        else
            return 'p'
        endif
    endfunction
    
    return s
endfunction

