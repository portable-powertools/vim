let g:PL_verbose=1
fun! g:PLLog(msg)
    if g:PL_verbose
        call xolox#misc#msg#warn(a:msg)
    endif
endf

fun! g:TargetRangeForVarCatch(varCatch, ...) abort
    let [a:id, a:expression, a:sourcelinenr, a:targetLineNr, a:targetIdx] = a:varCatch
    let a:length = get(a:, 1, len(a:id))
    let a:targetLineNr = get(a:, 2, a:targetLineNr)
    return [[0, a:targetLineNr, a:targetIdx+1, 0], [0, a:targetLineNr, a:targetIdx+a:length, 0]]
endf

" VarCatch return signature: [varCatch1, ..]
" varCatch element: [identifier, expression, linenr, targetLineNr, targetIdx]
" this function gets one element, we unpack it
fun! g:VarRejoin(varCatch) abort
    let [a:id, a:expression, l:linenr, a:targetLineNr, a:targetIdx] = a:varCatch

    call PLLog('tryna substitute '.a:id.' with '.a:expression.' in line '.a:targetLineNr)
    let l:prevline = getline(a:targetLineNr)
    let l:substituted = substitute(l:prevline, '\V'.a:id, a:expression, 'g')
    call PLLog('substituted: ' . l:substituted . ', now inhabiting L'.a:targetLineNr)
    call setline(a:targetLineNr, l:substituted)
    return [g:TargetRangeForVarCatch(a:varCatch, len(a:expression)), a:varCatch]
endf

" speed is in percentile, 100 is default
fun! g:Client_GoToCatchvar(varCatch) abort
    let [a:id, a:expression, a:sourcelinenr, a:targetLineNr, a:targetIdx] = a:varCatch
    call cursor(a:targetLineNr, a:targetIdx+1)
endf

" speed is in percentile, 100 is default
fun! g:Client_Rejoin(varCatch, ...) abort
    let a:speed = get(a:, 1, 100)
    let [a:id, a:expression, a:sourcelinenr, a:targetLineNr, a:targetIdx] = a:varCatch
    call g:Client_ShowRejoinable([a:varCatch])
    let [l:rejoinResult; l:_] = g:VarRejoin(a:varCatch)
    call g:FlashLine(a:sourcelinenr, 2, (a:speed*100)/100)
    call call('g:FlashVisual', l:rejoinResult + [1, (a:speed*200)/100])
    return l:rejoinResult
endf

" VarCatch return signature: [varCatch1, ..]
" varCatch element: [identifier, expression, linenr, targetLineNr, targetIdx]
" this function gets one element, we unpack it
fun! g:Client_RejoinAndDel(varCatch, ...) abort
    let a:speed = get(a:, 1, 100)
    let [a:id, a:expression, a:sourcelinenr, a:targetLineNr, a:targetIdx] = a:varCatch

    call g:Client_ShowRejoinable([a:varCatch], (a:speed*30)/100)
    let [l:rejoinResult; l:_] = g:VarRejoin(a:varCatch)
    " call g:FlashLine(a:sourcelinenr, 1, 300)
    call g:FlashLine(a:sourcelinenr, 1, (a:speed*40)/100)
    call deletebufline(bufnr("%"), a:sourcelinenr)

    " this decreases the line number by 1 due to line deletion
    let l:adapted = map(l:rejoinResult, { idx,val -> g:IdxSet(val, 1, val[1] - 1) })
    call call('g:FlashVisual', l:adapted + [1, (a:speed*200)/100])
    return l:adapted
endf


fun! g:Client_ShowRejoinable(varCatches, ...) abort
    let a:speed = get(a:, 1, 100)
    for a:varCatch in a:varCatches
        let [a:id, a:expression, a:sourcelinenr, a:targetLineNr, a:targetIdx] = a:varCatch
        let l:targetRange = g:TargetRangeForVarCatch(a:varCatch)
        call call('g:FlashVisual', l:targetRange + [1, (300*a:speed)/100])
        call call('g:FlashLine', [a:sourcelinenr] + [1, (100*a:speed)/100])
        exec "sleep 200m"
    endfor
endf


fun! g:LeftCycleMetric(linelen, reference, pos) abort
    let l:transposedPos = a:pos
    if a:pos > a:reference
        let l:transposedPos = a:pos-a:linelen
    endif
    return a:reference - l:transposedPos
    
endf
fun! g:CompCatch(linelen, col, idx1, idx2, len1, len2) abort
    let l:isIn1 = 0
    let l:isIn2 = 0
    if a:col >= a:idx1+1 && a:col <= a:idx1+1+a:len1
        let l:isIn1 = 1
    endif
    if a:col >= a:idx2+1 && a:col <= a:idx2+1+a:len2
        let l:isIn2 = 1
    endif
    if l:isIn1
        return -1
    endif
    if l:isIn2
        return 1
    endif
    " let l:metr1 = min([abs(a:col-a:idx1-1), abs(a:col-a:idx1-a:len1-1)])
    " let l:metr2 = min([abs(a:col-a:idx2-1), abs(a:col-a:idx2-a:len2-1)])
    let l:metr1 = g:LeftCycleMetric(a:linelen, a:col, a:idx1+1)
    let l:metr2 = g:LeftCycleMetric(a:linelen, a:col, a:idx2+1)
    call PLLog('metrics: idx+m, idx+m'. a:idx1.' '.l:metr1.' '.a:idx2.' '.l:metr2)
    if l:metr1 == l:metr2
        return a:len1 - a:len2
    endif
    return l:metr1 - l:metr2
    
endf

" returns []
fun! g:VarCatch(linenr, linesabove, ...) abort
    let l:nearestCol = get(a:, 1, 9999999)
    let l:assignments = []
    let l:linehere = getline(a:linenr)
    for lidx in range(a:linesabove)
        let l:targetlinenr = a:linenr-1-lidx
        let l:match = g:PLAssignedVar(getline(l:targetlinenr))
        call PLLog('looking for catchable vars in line ' . l:targetlinenr)
        if !empty(l:match)
            let l:entry = add(l:match, l:targetlinenr)
            let l:assignments = add(l:assignments, l:entry)
        endif
    endfor
    call PLLog(string(l:assignments))
    " l:assignments: [[identifier, expression, linenr], ...]

    let l:matches=[]
    for ass in l:assignments
        let l:id = ass[0]
        " let l:lastIdx = strridx(l:linehere, l:id)
        let l:idx = match(l:linehere, '\m\<\V'.l:id.'\m\>') " TODO: word bounded occurences only. parametrize?
        call PLLog(l:idx . ' of '.l:id.'in '.l:linehere)
        if l:idx != -1
            let l:matches = add(l:matches, ass + [a:linenr, l:idx])
        endif
    endfor
    " l:matches: [[identifier, expression, linenr, targetLineNr, idxOfIdentifier], ..]
   
    let l:Sortf = { a1, a2 -> g:CompCatch(len(l:linehere), l:nearestCol, a1[4], a2[4], len(a1[2]), len(a2[2])) }
    let l:unsorted = copy(l:matches)
    let l:sorted = sort(l:matches, l:Sortf)

    " sorted l:matches by l:Sortf which is based on cursor
    return l:sorted
endf


fun! g:SetVisualScope(linenr, scope) abort
    call g:PLLog('setting visual scope on line '.a:linenr.', on scope '.string(a:scope))
    call setpos('.', [0, a:linenr, 0, 0])
    call setpos("'<", [0, a:linenr, a:scope[0], 0])
    call setpos("'>", [0, a:linenr, a:scope[1]-1, 0])
endf

fun! g:GetCursorTextobjBounds(obj) abort
    normal mc
    let l:left = getpos("'<")
    let l:right = getpos("'>")
    exec 'norm v'.a:obj."\<Esc>"
    let colLeft = getpos("'<")
    let colRight = getpos("'>")
    call setpos("'<", l:left)
    call setpos("'>", l:right)
    if colLeft == colRight || colLeft[1] != colRight[1] " if matches on different lines, no dice.
        return []
    else
        return [colLeft[2], colRight[2]+1]
endf
" eVar = fun(x.y)  # type: String
" looks for a term that is assigned a value in the specified line. if found,
" returns [term, assignedTerm]
fun! g:PLAssignedVar(line) abort
    " also allows vimscript with : and let
    let l:pat = '\v^\s*%(let)?\s*(\h[^[:blank:]=]*)\s*\=\s*(\S[^#]{-})\s*(#.*$)?$'
    " pure python syntax but doesnt allow all that is legal...
    " let l:pat = '\v^\s*(\h%(\i|[\[\]''"])*)\s*\=\s*(\S[^#]{-})\s*(#.*$)?$'
    let l:matches = matchlist(a:line, l:pat, 0, 0)
    if empty(l:matches)
        return []
    else
        return l:matches[1:2]
    endif
endf

fun! g:TryScope(scopes, ...) abort
    let l:scope = call(function('g:PLGetScopeHere'), [a:scopes]+a:000)
    if ! empty(l:scope)
        call g:SetVisualScope(line('.'), l:scope)
        exec "normal gv"
    endif
endf

fun! g:PLRexScope(line, pattern) abort
    let l:start = match(a:line, a:pattern, 0, 0)
    if l:start != -1
        let l:end = matchend(a:line, a:pattern, 0, 0)
        " We calculate in columns.. 1-based.....
        let l:result = [l:start+1, l:end+1]
        call g:PLLog('rex scope '.a:pattern.' matches ' . string(l:result))
        return l:result 
    else
        return []
    endif
endf

" optional: useInnerArgTextobj boolean (default: true)
fun! g:PLGetScope(linenr, colnr, scopeRexes, ...) abort
    let l:useInnerArg = get(a:, 1, 1)
    let l:cursor = getcurpos()
    let l:result = []
    try
        call setpos('.', [0, a:linenr, a:colnr, 0])
        let l:argscope = g:GetCursorTextobjBounds('ia')
        call g:PLLog('argscope: ' . string(l:argscope))
        if !empty(l:argscope)
            call g:PLLog('(builtin) inner-arg scope matches')
            return l:argscope
        else
            let l:line=getline(a:linenr)
            for rex in a:scopeRexes
                let l:rexscope = g:PLRexScope(l:line, l:rex)
                if !empty(l:rexscope)
                    call g:PLLog('rexscope '.string(l:rexscope).' has matched')
                    return l:rexscope
                endif
            endfor
        endif
        return []
    finally
        call setpos('.', l:cursor)
    endtry
endf

fun! g:PLClipScope(linenr, scope, danglingPattern, maxEnd, minStart) abort
    let l:line = getline(a:linenr)
    call g:PLLog('scope in clip is '.string(a:scope).'line is '.string(l:line))
    " columns are 1-based....
    let l:scopestr = strpart(l:line, a:scope[0]-1, a:scope[1]-a:scope[0])
    let l:clippedmatch = a:scope[0] + matchend(l:scopestr,  '^\v.{-}\ze'.a:danglingPattern.'\v$')
    call g:PLLog('clipped match for '.l:scopestr.'is at '. l:clippedmatch)
    if l:clippedmatch != a:scope[0]-1
        let l:clippedEnd = min([ l:clippedmatch, a:maxEnd ])
        let l:clippedStart = max([ a:scope[0], a:minStart ])
        return [l:clippedStart, l:clippedEnd]
    else
        call g:PLLog('error, clipping pattern did not match at all.')
    endif
endf


" Scopes:

fun! g:PL_scope_prefixpat(pattern)
    let l:pattern = '\v^\s*'.a:pattern.'\v\s*\zs(\S[^#]{-})\ze\s*(#.*$)?$'
    return l:pattern 
endf
"" More strict - keyword has to be first in the line
fun! g:PLMakeKWScopes(...)
    let l:result = []
    for pattern in a:000
        let l:result = add(l:result, g:PL_scope_prefixpat(pattern))
    endfor
    return result
endf


fun! g:PLGetScopeHere(scopes, ...) abort
    let l:clipCursorAsEnd = get(a:, 1, 0)
    let l:clipCursorAsStart = get(a:, 2, 0)
    let l:danglingExpr = get(a:, 3,  '\v\.*')

    let l:pos = getpos('.')
    let l:scope = g:PLGetScope(l:pos[1], l:pos[2], a:scopes)
    call g:PLLog('here scope method: '.string(l:scope))
    if !empty(l:scope)
        if l:clipCursorAsEnd
            let l:maxEnd = l:pos[2]+1
        else
            let l:maxEnd = 999999
        endif
        if l:clipCursorAsStart
            let l:minStart = l:pos[2]
        else
            let l:minStart = 1
        endif
        let l:clippedscope = g:PLClipScope(l:pos[1], l:scope, l:danglingExpr, l:maxEnd, l:minStart)
        if !empty(l:clippedscope)
            return l:clippedscope
        else
            return []
            call g:PLLog('here: scope empty')
        endif
    else
        return []
        call g:PLLog('here: scope empty')
    endif
endf
