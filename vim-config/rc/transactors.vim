""""""""""""""""
"  lh#prelude: "
""""""""""""""""

" function! lh#foo#bar#new() abort
"   let res = lh#object#make_top_type({})
"   call lh#object#inject_methods(res, s:k_script_name, ['get', 'set', 'name'...])
"   return res
" endfunction

let s:k_script_name = expand('<sfile>:p')
let s:verbose = get(s:, 'verbose', 0)
function! StMVerbose(...)
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

""""""""""""""""""
"  Context:      "
""""""""""""""""""
call StMVerbose(1)


" Feasible way to provide granular context: nest it, linearize after and map
" optionally, one dict with entries to attach to this object. empty parent: {}
function! Ctx(parent, ...) abort
let s = lh#object#make_top_type({ 'parent': a:parent })
call extend(s, a:0 > 0 ? a:1 : {})

    function! s.getLineage() dict abort
        if empty(self.parent)
            return [self]
        else
            return self.parent.lineage() + [self]
        endif
    endfunction
    " may take a default argument. if not specified, return only matching
    function! s.getAttrList(attr, ...) dict abort
        if a:0 == 0
            let mapped = map(self.getLineage(), {ctx -> get(ctx, a:attr, "___null___")})
            call filter(mapped, { x -> x !=# "___null___"})
        else
            call s:Verbose('getattrlist: getlineage: %s', self.getLineage())
            
            let mapped = map(self.getLineage(), {ctx -> get(ctx, a:attr, a:1)})
        endif
    endfunction
    " caution, this will also flatten attributes if they are lists
    function! s.getAttrListFlat(attr) dict abort
        return lh#list#flatten(self.getAttrList(a:attr, []))
    endfunction

    " this returns the "latest" attr in the context
    function! s.getAttr(attr) dict abort
        let attrList = self.getAttrList(a:attr)
        call lh#assert#not_empty(attrList)
        return attrList[-1]
    endfunction

    return s
endfunction
" optional flags which are added to tags.mapping, add a parent if you need it by hand
function! CtxMapping(...) abort
    return Ctx({}, { 'tags.mapping' : a:000 })
endfunction

""""""""""""""""""""
"  (tags helpers)  "
""""""""""""""""""""
fun! ModePatterns(char) abort
    "TODO: complete!
    if a:char == 'v'
        return [ModePattern('^x'), ModePattern('^v'), ModePattern('^')]
    elseif a:char == 'n'
        return [ModePattern('^n'), ModePattern('^')]
    elseif a:char == 'o'
        return [ModePattern('^o'), ModePattern('^')]
    endif
endf
fun! ModePattern(start) abort
    return '\v'.a:start.'(nore)?map'
endf
function! StMTags(...) abort
" nmap, nnoremap, xmap, autocmd, <expr>, etc
let s = lh#object#make_top_type({
        \ 'tags': a:000
        \ })
    "takes patterns and list of patterns alike, like ModePatterns('v'). OR semantic
    function! s.has(...) dict abort
        call xolox#misc#msg#info(LHStr('Source.has(', a:000, ')', self))
        let ls = []
        for a in a:000
            if type(a) == 3
                let ls = ls + a
            elseif type(a) == 1
                let ls = ls + [a]
            else
                throw 'StMSource.has : no valid arg: ' . string(a)
            endif
        endfor
        for c in self.tags
            for pat in ls
                if match(c, pat) != -1
                    call xolox#misc#msg#info(LHStr('Source.has match!', pat, c))
                    return 1
                else
                    call xolox#misc#msg#info(LHStr('Source.has no match', pat, c))
                endif
            endfor
        endfor
        return 0
    endfunction
    
    return s
endfunction

"""""""""""""""""
"  Transactor:  "
"""""""""""""""""

" static clients of transactors, i.e. loggers
" optional args are all registered as clients
let g:transactorStaff = []
function! Transactor(...) abort
    let s = lh#object#make_top_type({ 'clients': g:transactorStaff + a:000 })

    function! s.action(context, ...) dict abort
        return call(self._action, [a:context] + a:000)
    endfunction

    function! s._action(context, ...) dict abort
        let tContext = call(self.transformContext, [a:context] + a:000)
        let tArgs = call(self.transformArgs, [a:context] + a:000)
        return map(self.clients, { c -> call(c.action, [ tContext ] + tArgs)})
    endfunction

    "default implementations that do not transform anything
    function! s.transformContext(context, ...) dict abort
        return a:context
    endfunction

    function! s.transformArgs(context, ...) dict abort
        return a:000
    endfunction

    function! s.addClients(...) dict abort
        call extend(self.clients, a:000)
        return self.field
    endfunction

    return s
endfunction

"""""""""""""""
"  Operator:  "
"""""""""""""""

" global singleton for opfun
if ! exists('g:opfunCallbackStack')
    let g:opfunCallbackStack = lh#stack#new()
endif
fun! StMOpfun(...) abort
    echom printf('omode called with %s', a:000)
    let receiver = g:opfunCallbackStack.pop()
    call(receiver, a:000)
endf

function! OpfunTransactor(nextTransactor, ...) abort
" an opfun transactor is transacting very rigidly: 
" wait for callback, wrap context in a new one indicating
" the opfun transaction and its arguments, and throw the call to the
" indicated transactor
let s = Transactor(a:nextTransactor)
    function! s.callback(...) dict abort
        let self.opfunArgs = a:000
        call(self._action, [self.lastContext] + self.lastArgs)
    endfunction
    
    function! s.transformContext(context, ...) dict abort
        return Ctx(a:context, {'opfunArgs': self.opfunArgs})
    endfunction

    function! s.action(context, ...) dict abort
        " TODO make a partially applicated callback
        let self.lastContext = a:context
        let self.lastArgs = a:000
        call g:opfunCallbackStack.push(self.callback)
        set opfun=StMOpfun
    endfunction

    return s
endfunction

" downstream context will have a field 'opdata' set to an OperatorData object
function! OperatorTransactor(...) abort
" call the action method of this operator with anything, 
" as long as somewhere upstream a tags.mapping has an 'opfun' member. 
let s = call('Transactor', a:000)
    function! s.action(context, ...) dict abort
        let args  = a:000
        let isOpfun = StMTags(a:context.getAttrListFlat('tags.mapping')).has('opfun')
        if isOpfun
            " TODO: clean: is this dirty or is it elegant? can't tell!
            let callbackTransactor = Transactor(self.clients)
            let callbackTransactor.action = self._action " TODO: complete
            return call(OpfunTransactor(callbackTransactor).action, [a:context] + args)
        else
            " TODO: clean is this shortcut o.k.?
            return call(self._action, [Ctx(a:context, {'opfunArgs': ['visual']})] + args)
        endif
    endfunction

    function! s.transformContext(context, ...) dict abort
        return Ctx(a:context, {'opdata': self.getOperatorData(a:context)})
    endfunction

    function! s.getOpfunArgs(context) dict abort
        let opfunArgSearch = a:context.getAttrList('opfunArgs')
        call lh#assert#not_empty(opfunArgSearch)
        
        let opfunArgsFound =opfun 
        if empty(opfunArgsFound)
            echoerr printf('No opfun args found!')
        endif
        return opfunArgsFound[-1]
    endfunction

    function! s:getOperatorData(context) dict abort
        let opcallArgs = a:context.getOpfunArgs()
        let isOpfunCallback = ! empty(opcallArgs)
        let mappingSpec = StMTags(a:context.getAttrListFlat('tags.mapping'))
        let argsForParsing = 'getOperatorData: something went wrong'
        " sanity check variables, should go away later but nice for debugging
        let nmapAssert = 0
        let vmapAssert = 0
        let opfunCallbackAssert = 0
        if isOpfunCallback
            let opfunCallbackAssert = 1
            let nmapAssert = 1
            if empty(opcallArgs)
                echoerr printf('opfun callback expected but not found in %s.getOperatorData: ', LHStr(a:context))
            else
                let argsForParsing = a:context.opcallArgs
            endif
        else
            let vmapAssert = 1
            let argsForParsing = ['visual']
        endif
        " Sanity checks and warnings to be changed later
        if opfunCallbackAssert
            if ! mappingSpec.has('opfun')
                let msg = 'getOperatorData: opfun arguments present, but source did not indicate that with a tag. context=' . LHStr(a:context)
                echoerr msg
            endif
        endif
        if nmapAssert " TODO: maybe n is not the only mode with an opfun?
            if ! mappingTags.has(ModePatterns('n'))
                let msg = 'getOperatorData: contest suggests this should be a n-mode mapping, but context=' . LHStr(a:context)
                echoerr msg
            endif
        endif
        if vmapAssert
            if ! mappingTags.has(ModePatterns('v'))
                let msg = 'getOperatorData: contest suggests this should be a v-mode mapping, but context=' . LHStr(a:context)
                echoerr msg
            endif
        endif
        return call('GetPresentOperatorData', argsForParsing)
    endfunction


    return s
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               CLIENT:                               "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" state machine and interface to VIM stuff
function! XPStateMachine() abort
let s = lh#object#make_top_type({
        \ 'lastDeletion': {}
        \ })

    function! s.reset() dict abort
        return self.lastDeletion = {}
    endfunction

    function! s.action(context, bla) dict abort
        if a:bla ==# 'x'
            echo 'we have an x!'
            let self.opdata = a:context.getAttr('opdata')
            let self.lastDeletion = g:CaptureDeletion(self.opdata.posrange)
            echom lastDeletion.whichPasteThen() . ' would be the paste key then'
        elseif a:bla ==# 'p'
            echo 'we have a p!'
        else
            echoerr 'don"t know what to do with that: '.LHStr(a:context, a:bla)
        endif
    endfunction

    return s
endfunction
function! XP(...) abort
    let stm = XPStateMachine()
    let this = Transactor(stm)
    let this.x_operator = OperatorTransactor(this)
    return this
endfunction

let xp_stateful = XP()
nmap <F10>_x :call xp_stateful.x_operator.action(CtxMapping('nmap', 'opfun'), 'x')<CR>g@
xmap <F10>_x :call xp_stateful.x_operator.action(CtxMapping('xmap'), 'x')<CR>
nmap <F10>_p :call xp_stateful.action(CtxMapping('nmap'), 'p')<CR>

