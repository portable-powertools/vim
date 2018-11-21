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
fun! s:inject(obj, mname, sname) abort
    call lh#object#inject(a:obj, a:mname, a:sname, s:k_script_name)
endf
fun! StObject() abort
    return lh#object#make_top_type({})
endf
" call StMVerbose(1)
""""""""""""""""""
"  Context:      "
""""""""""""""""""

function! s:getSNR(...)
  if !exists("s:SNR")
    let s:SNR=matchstr(expand('<sfile>'), '<SNR>\d\+_\zegetSNR$')
  endif
  return s:SNR . (a:0>0 ? (a:1) : '')
endfunction

fun! s:Script_Verbosity(...) abort dict
    let self.verbosity = get(a:, 1, 1)
endf
fun! s:Script_Log(...) abort dict
    return call('lh#log#this', a:000)
endf
fun! s:Script_LogV(...) abort dict
    if self.verbose
        return call(self.log, a:000)
    endif
    return call('lh#log#this', a:000)
endf
fun! s:Script_Factory() abort dict
    return Class(self.snr)
endf
function! Script(snr) abort
let s = lh#object#make_top_type({ 'snr': a:snr, 'verbosity': 0 })
    call s:inject(s, 'log', 'Script_Log')
    call s:inject(s, 'logV', 'Script_LogV')
    call s:inject(s, 'verbose', 'Script_Verbosity')
    call s:inject(s, 'objectFactory', 'Script_Factory')
    return s
endfunction


fun! s:Object_tostring(...) abort dict
    let cp = copy(self)
    for [k,V] in items(cp)
        if k[0] == '_' && k !=# '__lhvl_oo_type' && k !=# '_to_string' && type(V) != type(function('type'))
            let cp[k] = '...'
        endif
    endfor
    let handled_list = a:0 > 0 ? a:1 : []
    let funtype = type(function('type'))
    let attributes = filter(copy(cp), { i,v -> type(v) != funtype })
    return lh#object#_to_string(attributes, handled_list)
endf
fun! s:Object_inject(mname, mscriptname) abort dict
    call self._fac.smethod(a:mname, a:mscriptname)
endfun
fun! s:Object_set(key, val) abort dict
    " TODOitclean: performance?
    let self[a:key] = a:val
    return self
endf

" This is the object prototype
fun! Class_init(factory) abort
    let obj = lh#object#make_top_type({})
    let obj._factory = a:factory
    call s:inject(obj, '_to_string', 'Object_tostring')
    call s:inject(obj, 'set', 'Object_set')
    call s:inject(obj, 'inject', 'Object_inject')
    return obj
endf


fun! s:Class_attr(name, value) abort dict
    let self.obj[a:name] = a:value
    call add(self.attrs, a:name)
    return self
endf
fun! s:Class_smethod(mname, mscriptname) abort dict
    call lh#object#inject(self.obj, a:mname, a:mscriptname, self.snr)
    call add(self.methods, a:mname)
    return self
endf
fun! s:Class_finalize() abort dict
    return self.obj
endf

fun! Class(snr, ...) abort
    let s = lh#object#make_top_type({})
    let s.name = get(a:, 1, '<anonym>')
    let s.snr = a:snr
    let s.methods = []
    let s.attrs = []
    
    call s:inject(s, 'smethod', 'Class_smethod')
    call s:inject(s, 'attr', 'Class_attr')
    call s:inject(s, 'finalize', 'Class_finalize')

    let s.obj = Class_init(s)
    return s
endf

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                 Ctx interface, wrapper, CtxMapping                  "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


    function! s:Ctx_getLineage() dict abort
        if empty(self._parent)
            return [self]
        else
            return self._parent.getLineage() + [self]
        endif
    endfunction
    function! s:Ctx_getAttrList(attr, ...) dict abort
        " call s:Log('getattrlist attr %1, ... %2', a:attr, a:000)
        " call s:Log('getattrlist self %1', self)
        let lineage = self.getLineage()
        " call s:Log('getattrlist lineage: %1', map(copy(lineage), {i,v -> LHStr(v)}))
        " call s:Log('test %1', get(lineage[0], a:attr, 'default'))
        
        if a:0 == 0
            " call s:Verbose('Ctx_getAttrList: %1', lineage)
            let mapped = map(copy(lineage), {i, ctx -> get(ctx, a:attr, "___null___")})
            call filter(mapped, { i, x -> ( type(x) != type('string') || x != "___null___" )})
            call s:Verbose('getattrlist mapped if: %1', mapped)
        else
            " call s:Verbose('getattrlist: getlineage: %1', self.getLineage())
            let mapped = map(copy(lineage), {i, ctx -> get(ctx, a:attr, a:1)})
            " call s:Verbose('getattrlist mapped else: %1', mapped)
            
            " call s:Verbose('mapped: %1', mapped)
            
        endif
        return mapped
    endfunction
    function! s:Ctx_getAttrListFlat(attr) dict abort
        let attrlist = self.getAttrList(a:attr, [])
        let result = lh#list#flatten(attrlist)
        " call s:Log(LHStr(attrlist) . 'attrlist')
         
        " call s:Log(LHStr(result) . 'flattenResult')
         
        return result
    endfunction
    "returns the latest
    function! s:Ctx_getAttr(attr) dict abort
        let attrList = self.getAttrList(a:attr)
        call lh#assert#not_empty(attrList)
        "TODO: catch that sensibly at client side (hasAttr)
        return attrList[-1]
    endfunction
    function! s:Ctx_call(nestedmember, ...) dict abort
        let lineage = self.getLineage()
        for link in lineage
            if has_key(link, a:nestedmember)
                let Method = link[a:nestedmember]
                return call(Method, a:000, link)
            endif
        endfor
        throw 'not implemented in context lineage: '.a:nestedmember
    endfunction
    fun! s:Ctx_inject(mname, mscriptname) abort dict
        call s:inject(self, a:mname, a:mscriptname)
        return self
    endf
    fun! s:Ctx_set(key, val) abort dict
        " TODOitclean: performance?
        let self[a:key] = a:val
        return self
    endf

    fun! s:Ctx_tostring(...) abort dict
        let cp = copy(self)
        for [k,V] in items(cp)
            if k[0] == '_' && k !=# '__lhvl_oo_type' && k !=# '_to_string' && type(V) != s:k_fun_type
                let cp[k] = '...'
            endif
        endfor

        let handled_list = a:0 > 0 ? a:1 : []
        let attributes = filter(copy(cp), 'type(v:val) != s:k_fun_type')
        
        return lh#object#_to_string(attributes, handled_list)
    endf

" Feasible way to provide granular context: nest it, linearize after and map
" optionally, one dict with entries to attach to this object. empty parent: {}
function! Ctx(parent, ...) abort
    let s = lh#object#make_top_type({ '_parent': a:parent })
    call extend(s, a:0 > 0 ? a:1 : {})
    call s:inject(s, 'getLineage', 'Ctx_getLineage')
    call s:inject(s, 'getAttrList', 'Ctx_getAttrList')
    call s:inject(s, 'getAttrListFlat', 'Ctx_getAttrListFlat')
    call s:inject(s, 'getAttr', 'Ctx_getAttr')
    call s:inject(s, 'callUp', 'Ctx_call')
    call s:inject(s, 'inject', 'Ctx_inject')
    call s:inject(s, 'set', 'Ctx_set')
    call s:inject(s, '_to_string', 'Ctx_tostring')
    return s
endfunction


fun! s:CtxMapping_getMapTags() abort dict
    return self.getAttrListFlat('tags_mapping')
endf
" optional flags which are added to tags_mapping, add a parent if you need it by hand
function! CtxMapping(...) abort
    let s = Ctx({}, { 'tags_mapping' : a:000 })
    call s:inject(s, 'getMapTags', 'CtxMapping_getMapTags')
    return s
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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                              StmTags class                          "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" or semantic, takes both lists or single patterns
function! s:StmTags_has(...) dict abort
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
                " call xolox#misc#msg#info(LHStr('Source.has match!', pat, c))
                return 1
            else
                " call xolox#misc#msg#info(LHStr('Source.has no match', pat, c))
            endif
        endfor
    endfor
    return 0
endfunction

function! StMTags(...) abort
" nmap, nnoremap, xmap, autocmd, <expr>, etc
let s = lh#object#make_top_type({ 'tags': a:000 })
    call s:inject(s, 'has', 'StmTags_has')
    return s
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                        Transactor interface                         "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TODOitclean: it is a "BroadcastTransactor", really, and you can specify the broadcasting method
" by injecting clients() and broadcast(client, ...)
" TODOitclean: separate sink/receiver and broadcast/transactor semantics

    " This method should not be injected from somewhere else
    " implements receiver and translator semantics for now
    function! s:Transactor__action(context, ...) dict abort
        " call s:Verbose('--->Transactor__action| of (%1): (args; context): (%2; %3)', self.name, a:000, a:context)
        let tContext = call(self.transformContext1, [a:context])
        let tContext = call(self.transformContext, [tContext] + a:000)
        let tArgs = call(self.transformArgs, [a:context] + a:000)
        
        call s:Verbose('Transactor__action--->| of (%1): (args; context): (%2; %3)', self.name, tArgs, tContext)
        let callPayload = [ tContext ] + tArgs
        " call s:Verbose('Transactor__action client payload: %1', tArgs)
        let invocResults = []
        for c in self.getClients()
            let result = call(c.action, callPayload)
            call add(invocResults, result)
        endfor
        return invocResults
    endfunction
  
    " RECEIVER semantics
    " Main interface method
    " This method may be injected to control how the transactor translates actions other than context TF (see below)
    " It may eg. be used to define a sink
    function! s:Transactor_action(context, ...) dict abort
        return call(self._action, [a:context] + a:000)
    endfunction

    " TRANSLATOR sematics
    " default impl, may be overwritten, part of the interface wrt. broadcasting (not so much for a sink)
    function! s:Transactor_transformContext(context, ...) dict abort
        return a:context
    endfunction
    function! s:Transactor_transformContext1(context) dict abort
        return a:context
    endfunction
    function! s:Transactor_transformArgs(context, ...) dict abort
        return a:000
    endfunction
    fun! s:Transactor_getClients() abort dict
        return self.hard_clients
    endf

    " convenience to not have to override the method
    " may be effectless if clients() has been overridden
    function! s:Transactor_addClients(...) dict abort
        call extend(self.hard_clients, a:000)
    endfunction

    let s:k_fun_type = type(function('type'))
    fun! s:MT_tostring(...) abort dict
        let cp = copy(self)
        call remove(cp, 'hard_clients')
        call remove(cp, 'name')
        let clients = self.getClients()
        let faux_clients = []
        for c in clients
            if !empty(get(c, '_action', {}))
                call add(faux_clients, lh#fmt#printf('%1', c.name))
            else
                call add(faux_clients, lh#fmt#printf('??:%1', c))
            endif
        endfor
        for [k,V] in items(cp)
            if k[0] == '_' && k !=# '__lhvl_oo_type' && k !=# '_to_string' && type(V) != s:k_fun_type
                let cp[k] = '...'
            endif
        endfor


        let handled_list = a:0 > 0 ? a:1 : []
        let attributes = filter(copy(cp), 'type(v:val) != s:k_fun_type')
        " call s:Verbose('filtered: %1', string(attributes))
        
        let resultfmt = lh#fmt#printf("{ TA:%1 -> %2 | %s END:TA:%1 }", self.name, faux_clients)
        let body = lh#object#_to_string(attributes, handled_list)
        return printf(resultfmt, body)
    endf


" TODOitclean: Eierlegende Wollmilchsau, this will bite me later
function! MultiTransactor() abort
    let s = lh#object#make_top_type({ 'hard_clients': [] })
    call s:inject(s, 'action', 'Transactor_action')
    call s:inject(s, '_action', 'Transactor__action')
    call s:inject(s, 'transformContext', 'Transactor_transformContext')
    call s:inject(s, 'transformContext1', 'Transactor_transformContext1')
    call s:inject(s, 'transformArgs', 'Transactor_transformArgs')
    call s:inject(s, 'getClients', 'Transactor_getClients')
    call s:inject(s, 'addClients', 'Transactor_addClients')

    call s:inject(s, '_to_string', 'MT_tostring')
    let s.name = 'generic_Transactor'

    return s
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                       OpfunTransactor object                        "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" global singleton for opfun
if ! exists('g:opfunCallbackStack')
    let g:opfunCallbackStack = lh#stack#new()
endif
fun! StMOpfun(...) abort
    let Receiver = g:opfunCallbackStack.pop()
    " call s:Verbose('Receiver %1', Receiver)
    call call(Receiver, a:000)
endf


    function! s:OpfT_callback(...) dict abort
        let self.opfunArgs = a:000
        call s:Verbose('OpfunTransactor: callback is calling %1 + %2', self.lastArgs, self.lastContext)
        call call(self._action, [self.lastContext] + self.lastArgs)
    endfunction
    function! s:OpfT_transformContext(context, ...) dict abort
        call s:Verbose('OpfT_transformContext is called')
        return Ctx(a:context, {'opfunArgs': self.opfunArgs})
    endfunction
    function! s:OpfT_action(context, ...) dict abort
        " TODO make a partially applicated callback
        let self.lastContext = a:context
        let self.lastArgs = a:000
        call g:opfunCallbackStack.push(self.callback)
        set opfunc=StMOpfun
    endfunction

function! OpfunTransactor(nextTransactor) abort
    let s = MultiTransactor()
    call s:inject(s, 'callback', 'OpfT_callback')
    call s:inject(s, 'transformContext', 'OpfT_transformContext')
    call s:inject(s, 'action', 'OpfT_action')
    let s.name = 'generic_OpfunTransactor'
    call s.addClients(a:nextTransactor)

    return s
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                       OperatorTransactor object                        "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    " TYPE:
    " Pre_context: sorta specifies preconditions. can be applied from the 
    " outside to peek inside the behavior of the transactor
    fun! OperatorTransactorCtxPre(actionCtx) abort
        return Ctx(a:actionCtx)
                    \.inject('usesOpfun', 'OperatorTransactorCtxPre_usesOpfun')
    endfun
    fun! s:OperatorTransactorCtxPre_usesOpfun() abort dict
        let tags = StMTags(self.callUp('getMapTags'))
        return tags.has('opfun')
    endf

    " TYPE:
    " Post_context: specifies what clients can expect (to call, to retrieve)
    " it is conveniently the transformContext method, which is a super nice 
    " outcome of this modeling :)
    fun! s:OperatorTransactorCtxPost(ctx) abort dict
        return Ctx(a:ctx)
                    \.inject('getOpfunArgs', 'OT_Ctx_getOpfunArgs')
                    \.inject('getOperatorData', 'OT_Ctx_getOperatorData')
    endfun
    fun! s:OT_Ctx_getOpfunArgs() abort dict
        return self.getAttr('opfunArgs')
    endf
    fun! s:OT_Ctx_getOperatorData() abort dict
        let opcallArgs = self.getOpfunArgs()
        call s:Verbose('calling getopdata with %1', LHStr(opcallArgs))
        
        return call('GetPresentOperatorData', opcallArgs)
    endf

    " Intermediary_representations: (both possible routes)
    fun! OperatorTransactorCtxFromOpfT(ctx) abort
        return a:ctx " OpfT already set 'opfunArgs' for us
    endfun
    fun! OperatorTransactorCtxWithVisual(ctx) abort
        return Ctx(a:ctx)
                    \.set('opfunArgs', ['visual'])
    endfun
   
    " transaction piece of porcelain
    fun! s:OT_action(context, ...) dict abort
        let ctx = OperatorTransactorCtxPre(a:context)
        if ctx.usesOpfun()
            return call(self._opfunRedirTransactor.action, [ctx] + a:000)
        else
            return call(self._action, [OperatorTransactorCtxWithVisual(ctx)] + a:000)
        endif
    endfun

    " how to accept the callback from the opfun transactor
    fun! s:OT_opfunc_cb_sink_action(context, ...) abort dict
        call s:Verbose('opfunc sink called, redirecting to %1', self._OTParent)
        return call('s:Transactor__action', [OperatorTransactorCtxFromOpfT(a:context)] + a:000, self._OTParent)
    endf

" downstream context will have a field 'opdata' set to an OperatorData object
function! OperatorTransactor() abort
" call the action method of this operator with anything, 
" as long as somewhere upstream a tags_mapping has an 'opfun' member. 
let s = MultiTransactor()
    call s:inject(s, 'action', 'OT_action')
    call s:inject(s, 'transformContext1', 'OperatorTransactorCtxPost')
    let s.name = 'generic_OperatorTransactor'

    let s._callbackSinkTransactor = MultiTransactor()
        let s._callbackSinkTransactor._OTParent = s
        call s:inject(s._callbackSinkTransactor, 'action', 'OT_opfunc_cb_sink_action')
        let s._callbackSinkTransactor.name = 'OT.sink'

    let s._opfunRedirTransactor = OpfunTransactor(s._callbackSinkTransactor)
        let s._opfunRedirTransactor.name = 'OT.opfun'
    
    return s
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               CLIENT:                               "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" call s:Verbose('-----------------')

    function! s:xp_reset() dict abort
        let self.lastDeletion = {}
    endfunction
    function! s:xp_action(context, bla) dict abort
        if a:bla ==# 'x'
            call s:Verbose('xp_action on context %1', a:context)
            
            let opdata = a:context.callUp('getOperatorData')
            call s:Verbose('opdata: %1', opdata)
            
            call opdata.flash(2, 200)

            let self.lastDeletion = g:CaptureDeletion(opdata.posrange)
            call s:Log(self.lastDeletion.whichPasteThen() . ' would be the paste key then')
            
        elseif a:bla ==# 'p'
            echo 'we have a p!'
        else
            echoerr 'don"t know what to do with that: '.LHStr(a:bla)
        endif
    endfunction

" state machine and interface to VIM stuff
function! XPStateMachine() abort
let s = lh#object#make_top_type({ 'lastDeletion': {} })

    call s:inject(s, 'reset', 'xp_reset')
    call s:inject(s, 'action', 'xp_action')
    call s.reset()
    return s
endfunction

function! XP(...) abort
    let stm = XPStateMachine()
    let this = MultiTransactor()
        call this.addClients(stm)
        let this.name = 'XP'

    " operatorTransactor offers OperatorTransactorCtxPre/Post()
    " for its entry and broaddcast views of the data.
    " Post is only producible by shooting data through, Pre is free.
    let this.x_operator = OperatorTransactor()
        call this.x_operator.addClients(this)
        let this.x_operator.name = 'XP.x'
    " call s:Verbose('dbg1: xop: %1', this.x_operator)
    return this
endfunction

let xp_stateful = XP()
nmap ;zx :call xp_stateful.x_operator.action(CtxMapping('nmap', 'opfun'), 'x')<CR>g@
xmap ;zx :call xp_stateful.x_operator.action(CtxMapping('xmap'), 'x')<CR>
nmap ;zp :call xp_stateful.action(CtxMapping('nmap'), 'p')<CR>


