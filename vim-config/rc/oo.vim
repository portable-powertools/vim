let s:k_oo_snr = expand('<sfile>:p')


function! s:BootstrapInjector() abort
    let s = lh#object#make_top_type({})
    let s.prtfmt = 'BS method: "%1" <- %2 from '.s:k_oo_snr
    call lh#object#inject(s, 'inject', 'BootstrapInjector_injectHere', s:k_oo_snr)
    return s
endfunction
    fun! s:BootstrapInjector_injectHere(object, localname, funname) abort dict
        call lh#object#inject(a:object, a:localname, a:funname, s:k_oo_snr)
    endf
let s:b_injector = s:BootstrapInjector()

" helper functions
fun! FilterClassMembers(classrepr, ...) abort
    let filterpats = a:000
    let cp = copy(a:classrepr)
    for [k,V] in items(cp)
        " if k[0] == '_' && k !=# '__lhvl_oo_type' && k !=# '_to_string' && type(V) != type(function('type'))
        "     let cp[k] = '...'
        " endif
        for p in filterpats
            if match(k, p) >= 0
                unlet cp[k]
            endif
        endfor
    endfor
    let funtype = type(function('type'))
    let attributes = filter(cp, { i,v -> type(v) != funtype })
    return attributes
endf
fun! s:StrTimes(str, times, ...) abort
    return join(repeat([a:str], a:times), get(a:, 1, ''))

endf
fun! s:KeyForEntity(encountered, value) abort
    if ! lh#list#contain_entity(values(a:encountered), a:value)
        return '###NULL###'
    endif
    for [k,V] in items(a:encountered)
        if V is a:value
            return k
        endif
    endfor
    return '###NULL###'
endf
fun! Dict_pprint(dict, ...) abort
    let depth = get(a:, 1, 0)
    let encountered = get(a:, 2, {})
    let printRepeated = get(a:, 3, 0)
    let vargs = [a:dict, depth, encountered, printRepeated]
    if a:0 > 3
        let Dictmap = a:4
        let vargs = vargs + [Dictmap]
    endif
    if type(a:dict) == type([])
        let entkey = s:KeyForEntity(encountered, a:dict)
        if entkey !=# '###NULL###' && !printRepeated
            return lh#fmt#printf("[...]# :%1\n", entkey)
        endif
        if len(a:dict) == 0
            return "[]\n"
        endif
        if len(a:dict) == 1 && type(a:dict[0]) != type([]) && type(a:dict) != type({})
            return lh#fmt#printf("[ %1 ]\n", lh#object#_to_string(a:dict[0], values(encountered)+[a:dict]))
        endif
        let pretty = "[ #". len(encountered)."\n"
        let encountered[len(encountered)] = a:dict
        for le in a:dict
            let entryPretty = call('Dict_pprint', [le, depth+1]+vargs[2:])
            let pretty = pretty . s:StrTimes("\t", depth+1).entryPretty
        endfor
        let pretty .=  s:StrTimes("\t", depth)."]\n"
        return pretty
    elseif type(a:dict) == type({})
        let entkey = s:KeyForEntity(encountered, a:dict)
        if entkey !=# '###NULL###' && !printRepeated
            return lh#fmt#printf("[...] :%1\n", entkey)
        endif
        if len(a:dict) == 0
            return "{}\n"
        endif
        if len(a:dict) == 1 && type(items(a:dict)[0][1]) != type([]) && type(items(a:dict)[0][1]) != type({})
            return lh#fmt#printf("{ %1 }\n", lh#object#_to_string(items(a:dict)[0][1], values(encountered)+[a:dict]))
        endif
        if exists('Dictmap')
            let subj = lh#function#execute(Dictmap, a:dict)
        else
            let subj = a:dict
        endif
        let Sortfun = function('s:cmpDictkey', [subj])
        let subjkeys_sorted = sort(keys(subj), Sortfun)
        let maxlen = (max(map(keys(subj), {i,s -> strchars(s)})))
        let prefix = has_key(a:dict, '__class__') ? a:dict.__class__.getName() . ' ' : ''
        let pretty = prefix."{ #" . len(encountered) . "\n"
        let encountered[len(encountered)] = a:dict
        for k in subjkeys_sorted
            let thisIndent = (maxlen/8)-(strchars(k)/8) + 1
            let V = get(subj, k)
            let entryPretty = printf("%s%s-> %s", k, s:StrTimes("\t", thisIndent), call('Dict_pprint', [V, depth+1]+vargs[2:]))
            let pretty = pretty . s:StrTimes("\t", depth+1).entryPretty
        endfor
        let pretty .=  s:StrTimes("\t", depth)."}\n"
        return pretty
    else
        return lh#object#_to_string(a:dict, encountered)."\n"
    endif
endf

fun! s:cmpDictkey(d, k1, k2) abort
    let cmplist = [[0,0],[empty(a:d[a:k2]),0]] " comparison metric, meaning: empty, oneline
    let idx = a:k1
    let kidx = 0
    if type(a:d[idx]) == type({})
        let cmplist[kidx][0] = empty(a:d[a:k1])

        if len(a:d[idx]) == 1 && type(items(a:d[idx])[0][1]) != type([]) && type(items(a:d[idx])[0][1]) != type({})
            let cmplist[kidx][1] = 1
        endif
    elseif type(a:d[idx]) == type([])
        if len(a:d[idx]) == 1 && type(a:d[idx][0]) != type([]) && type(a:d[idx][0]) != type({})
            let cmplist[kidx][1]
        endif
    else
        let cmplist[kidx][1] = 1
    endif


    let idx = a:k2
    let kidx = 1
    if type(a:d[idx]) == type({})
        let cmplist[kidx][0] = empty(a:d[a:k1])

        if len(a:d[idx]) == 1 && type(items(a:d[idx])[0][1]) != type([]) && type(items(a:d[idx])[0][1]) != type({})
            let cmplist[kidx][1] = 1
        endif
    elseif type(a:d[idx]) == type([])
        if len(a:d[idx]) == 1 && type(a:d[idx][0]) != type([]) && type(a:d[idx][0]) != type({})
            let cmplist[kidx][1]
        endif
    else
        let cmplist[kidx][1] = 1
    endif

    let score1 = 0*cmplist[0][0] + 2*cmplist[0][1]
    let score2 = 0*cmplist[1][0] + 2*cmplist[1][1]
    if score1 == score2
        return s:Strcmp(a:k1, a:k2)
    endif
    return score2 - score1

endf

function! s:Strcmp(str1, str2)
    if a:str1 < a:str2
        return -1
    elseif a:str1 == a:str2
        return 0
    else
        return 1
    endif
endfunction

" Prototype: could have very complex implementation, but that is hidden
" anyways, for now it is just the object, with injected methods and fields.
    " 
    " ProtoField(id, default, ... [validation, init, ...]) see attr.s python model. complex! includes methods!

" Mutable class
" An actual class is a function that produces a pre-populated ClassFactory (my be immutable-ized...)
" * the actual constructor is living in factory.constr 
" * the initializator (pythons __init__) is settable as dictionary function through factory interface
"  - interface of __init__ is, abort dict("this") (...)
"  - by default, zero-arg-constructor, which does nothing
" * class.init [dict](...) is the interface method which should not be reassigned through client
"   - self is still pointing to the factory
"   - takes arguments a:000, makes a copy of self.prototype, named 'this'
"   - pas
" init: dictionary function with a fixed name, lives on factory
" porcelain: injection, construction
fun! ClassFactory() abort
    let s = lh#object#make_top_type({})

    " Injectors: define how the method(...)  and attr(...) calls get interpreted
    " Alternatively, the full-blown .inject(injector, ...) method is always available
    " Transitively, one can even access .prototype and do whatever with it.

    " Placeholders for function injections
    let s.injections = []
    let s.names = lh#stack#new(['root'])
    let s.attrInjectors = lh#stack#new()
    let s.methodInjectors = lh#stack#new()
    let s.staticmethodInjector = {}

    call s:b_injector.inject(s, '_to_string', 'ClassFactory_tostring')
    call s:b_injector.inject(s, 'pprint', 'ClassFactory_pprint')
    call s:b_injector.inject(s, 'getName', 'ClassFactory_getName')
    
    call s:b_injector.inject(s, 'allocProto', 'ClassFactory_allocProto')

    " Immutable_Interface:
    call s:b_injector.inject(s, 'fork', 'ClassFactory_fork') " returns an independent instance of this factory
    call s:b_injector.inject(s, 'inst', 'ClassFactory_constructor') " constructs the object
    call s:b_injector.inject(s, 'dict', 'ClassFactory_dict_constructor')
    call s:b_injector.inject(s, 'fork_named', 'ClassFactory_fork_named')

    " TODOitclean: finish/freeze these methods generically
    " TODOiclean: should be able to do away with this awful state-based stuff here.
    " separate construct-time hooks if necesarry!

    " These are strictly to enable a separate meaning for method and attr in a controlled setting,  where at the end, a popMethodInjector will follow. Pop where you Push!
    call s:b_injector.inject(s, 'pushMethodInjector', 'ClassFactory_pushMethodInjector')
    call s:b_injector.inject(s, 'pushAttrInjector', 'ClassFactory_pushAttrInjector')
    call s:b_injector.inject(s, 'popMethodInjector', 'ClassFactory_popMethodInjector')
    call s:b_injector.inject(s, 'popAttrInjector', 'ClassFactory_popAttrInjector')

    " This shold all happen at script level etc.
    call s:b_injector.inject(s, 'setStaticmethodInjector', 'ClassFactory_setStaticmethodInjector')
    call s:b_injector.inject(s, 'defaultMethodInjector', 'ClassFactory_defaultMethodInjector')
    call s:b_injector.inject(s, 'defaultAttrInjector', 'ClassFactory_defaultAttrInjector')

    call s:b_injector.inject(s, 'finish', 'ClassFactory_finish')

    " Factory_interface:
    " many more possible, let's rely on default-injector methods and default-valued fields
    call s:b_injector.inject(s, 'inject', 'ClassFactory_inject')
    call s:b_injector.inject(s, 'inject_class', 'ClassFactory_inject_class')

    " convenience functions that relegate to inject
    call s:b_injector.inject(s, 'attr', 'ClassFactory_add_default_valued_attr')
    call s:b_injector.inject(s, 'method', 'ClassFactory_add_default_script_method')
    call s:b_injector.inject(s, 'staticmethod', 'ClassFactory_injectstaticmethod')

    return s
endf
    fun! s:InjectionFormat(inj) abort
        let sep = get(a:, 1, '')
        let [injector, args] = a:inj
        let defaultfmt = '<unrep inj> %1'
        let fmt = get(injector, 'prtfmt', defaultfmt)
        let fmtargs = args
        if fmt == defaultfmt
            let fmtargs = [args]
        endif
        return call('lh#fmt#printf', [fmt] + fmtargs)
    endf

    fun! s:ClassFactory_getName() abort dict
        return join(self.names.values, '<-')
    endf
    fun! s:ClassFactory_fork_named(name) abort dict
        " TODOitclean: this method is unfreezing, fork is not; but maybe semantically more obvious?
        let forked = self.fork()
        call forked.names.push(a:name)
        return forked
    endf
    fun! s:ClassFactory_tostring(...) abort dict
        let cp = lh#object#make_top_type({})
        let cp.name = self.getName()
        let cp.members = map(copy(self.injections), {i,x -> s:InjectionFormat(x)})
        return lh#object#_to_string(FilterClassMembers(cp, '^name$'), get(a:, 1, []))
    endf
    fun! s:ClassFactory_pprint() abort dict
        let cp = lh#object#make_top_type({})
        let cp.name = self.getName()
        let cp.members = map(copy(self.injections), {i,x -> s:InjectionFormat(x)})
        return lh#fmt#printf('Class %1 ', self.getName()).Dict_pprint(FilterClassMembers(cp, '^name$'))
    endf
    fun! s:ClassFactory_allocProto() abort dict
        let alloc = {}
        for i in reverse(copy(self.methodInjectors.values))
            if has_key(i, 'finish')
                let mine = []
                for [injtor, args] in a:injections
                    if injtor == i
                        call add(mine, args)
                    endif
                endfor
                call i.finish(a:alloc, mine)
            endif
        endfor
        for [injector, payload] in self.injections
            call call(injector.inject, [alloc] + payload)
        endfor
        for i in (self.methodInjectors.values)
            if has_key(i, 'finish')
                " let mine = []
                " for [injtor, args] in a:injections
                "     if injtor == i
                "         call add(mine, args)
                "     endif
                " endfor
                call i.finish(a:alloc)
            endif
        endfor
        return alloc
    endf

    " Public_immutable_interface:
    fun! s:ClassFactory_finish() abort dict
        let self.frozen = 1
        return self
    endf
    fun! s:ClassFactory_fork() abort dict
        let alloc = deepcopy(self)
        return alloc
    endf
    fun! s:ClassFactory_dict_constructor(...) abort dict
        let alloc = self.allocProto()
        if has_key(alloc, '__init__')
            call call(alloc.__init__, a:000)
        endif
        return alloc
    endf
    fun! s:ClassFactory_constructor(...) abort dict
        let alloc = call(self.dict, a:000)
        " TODOitclean: fork/finish on construction? overhead!
        let alloc.__class__ = self
        return alloc
    endf

    "Builder: interface

    fun! s:ClassFactory_pushAttrInjector(injector) abort dict
        call self.attrInjectors.push(a:injector)
        return self
    endf
    fun! s:ClassFactory_pushMethodInjector(injector) abort dict
        call self.methodInjectors.push(a:injector)
        return self
    endf
    fun! s:ClassFactory_popAttrInjector() abort dict
        call self.attrInjectors.pop()
        return self
    endf
    fun! s:ClassFactory_popMethodInjector() abort dict
        call self.methodInjectors.pop()
        return self
    endf
    fun! s:ClassFactory_setStaticmethodInjector(injector) abort dict
        let self.staticmethodInjector = a:injector
        return self
    endf
    fun! s:ClassFactory_defaultAttrInjector() abort dict
        call lh#assert#false(self.attrInjectors.empty())
        return self.attrInjectors.top()
    endf
    fun! s:ClassFactory_defaultMethodInjector() abort dict
        call lh#assert#false(self.methodInjectors.empty())
        return self.methodInjectors.top()
    endf
    
    fun! s:ClassFactory_inject(injector, ...) abort dict
        call add(self.injections, [a:injector, a:000])
        return self
    endf
    fun! s:ClassFactory_inject_class(injector, ...) abort dict
        call call(injector.inject, [self] + a:000)
        return self
    endf
    fun! s:ClassFactory_add_default_valued_attr(...) abort dict
        call lh#assert#not_empty(self.defaultAttrInjector())
        call call(self.inject, [self.defaultAttrInjector()] + a:000 )
        return self
    endf
    fun! s:ClassFactory_add_default_script_method(...) abort dict
        call lh#assert#not_empty(self.defaultMethodInjector())
        call call(self.inject, [self.defaultMethodInjector()] + a:000 )
        return self
    endf
    fun! s:ClassFactory_injectstaticmethod(injector, ...) abort dict
        call call(self.inject, [self.staticmethodInjector] + a:000 )
        return self
    endf




" This is a class! call 'inst()' or 'dict()' on it to get an object
fun! ObjectClassFactory() abort
    return ClassFactory()
                \.pushMethodInjector(s:b_injector)
                \.method('_to_string',      'Object_tostring')
                \.method('_methods',      'Object_methods')
                \.method('pprint',          'Object_pprint')
                \.method('pprint_all',          'Object_pprint_all')
                \.method('set',             'Object_set')
                \.method('inject',          'Object_monkeypatch')
                \.popMethodInjector()
endf
    fun! s:Object_set(name, value) abort dict
        let self.obj[a:name] = a:value
        return self
    endf
    fun! s:Object_monkeypatch(mname, mscriptname) abort dict
        call self.__class__.defaultMethodInjector().inject(self, a:mname, a:mscriptname)
        return self
    endf
    fun! s:Object_tostring(...) abort dict
        return lh#object#_to_string(FilterClassMembers(self, '^_'), get(a:, 1, []))
    endf
    fun! s:Object_methods() abort dict
        return filter(copy(self), {k,V -> type(V) == type(function('type'))})
    endf
    fun! s:Object_pprint(...) abort dict
        return Dict_pprint(self, 0, {}, 0, lh#function#bind("FilterClassMembers(v:1_, '^_')"))
    endf
    fun! s:Object_pprint_all(...) abort dict
        return Dict_pprint(self, 0, {}, 0)
    endf


fun! Object() abort
    return g:Object.inst()
endf
let g:Object = ObjectClassFactory()
let g:Object.names.values = ["Object"]

"""""""""""""""
"  Injectors  "
"""""""""""""""

function! InjectorAttrDefault()
    let s = lh#object#make_top_type({})
    let s.prtfmt = 'attr: "%1", default: %2'
    call lh#object#inject(s, 'inject', 'InjectorAttrDefault_inject', s:k_oo_snr)
    return s
endfun
    fun! s:InjectorAttrDefault_inject(object, key, value) abort dict
        call lh#assert#type(a:key).is('string')
        let a:object[a:key] = a:value
    endfun

function! InjectorSnr(snr) abort
    let s = lh#object#make_top_type({ 'snr': a:snr })
    let s.prtfmt = 'method: "%1" <- %2 from '.a:snr
    call lh#object#inject(s, 'inject', 'InjectorSnr_inject', s:k_oo_snr)
    return s
endfunction
    fun! s:InjectorSnr_inject(object, localname, funname) abort dict
        call lh#object#inject(a:object, a:localname, a:funname, self.snr)
    endf

function! InjectorPrefixed(snr, prefix) abort
    let s = lh#object#make_top_type({ 'snr': a:snr, 'prefix': a:prefix })
    let s.prtfmt = 'method "'.a:prefix.'%1" from '.a:snr
    call lh#object#inject(s, 'inject', 'InjectorPrefixed_inject', s:k_oo_snr)
    return s
endfunction
    fun! s:InjectorPrefixed_inject(object, name) abort dict
        call lh#object#inject(a:object, a:name, self.prefix . '_' . a:name, self.snr)
    endf

" function! InjectorParsingAttrs(snr, prefix, parser) abort
"     let s = lh#object#make_top_type({ 'snr': a:snr, 'prefix': a:prefix, 'parser': a:parser })
"     call lh#object#inject(s, 'inject', 'InjectorParsingAttrs_inject', s:k_oo_snr)
"     let s.injector = InjectorSnr(a:snr)
"     return s
" endfunction
"     fun! s:InjectorParsingAttrs_inject(object, name) abort dict
"         throw "Using a script-parsing injector, no need to call .method - just define script variables prefixed with s:".self.prefix
"     endf
"     fun! s:InjectorParsingAttrs_inject(object) abort dict
"         let parsed = self.parser.linematches(Pattern_ScriptVarPrefixed(self.prefix))
"         for [whole, part] in parsed
"             call self.injector.inject(a:object, whole)
"         endfor
"     endf

function! InjectorParsingMethods(prefix, scriptpath, ...) abort
    let parser = a:0 > 0 ? a:1 : Fileparser(a:scriptpath)

    let s = lh#object#make_top_type({ 'snr': a:scriptpath, 'prefix': a:prefix, 'parser': parser })
    call lh#object#inject(s, 'inject', 'InjectorParsingMethods_inject', s:k_oo_snr)
    let s.injector = InjectorSnr(a:scriptpath) " TODOitclean: snr vs path
    let s.prtfmt = 'functions named "s:'.a:prefix.'{...}" from '.a:scriptpath
    return s
endfunction
    "TODO: call onDefault in classbuilder
    fun! s:InjectorParsingMethods_onDefault(classBuilder) abort dict
        throw "Using a script-parsing method injector, call inject(this) once on the class builder and define 's:' methods prefixed ".self.prefix
    endf
    fun! s:InjectorParsingMethods_inject(object) abort dict
        let parsed = self.parser.linematches(Pattern_ScriptFunPrefixed(self.prefix), 2)
        for [whole, part] in parsed
            call self.injector.inject(a:object, part, whole)
        endfor
    endf


" match groups: [full id, nonprefixed, ...] (length 9)
fun! Pattern_ScriptVarPrefixed(prefixpat) abort
    return '\V\C\^\s\*let s:\('.a:prefixpat.'\(\S\*\)\)\s\+='
endf
" match groups: [full id, nonprefixed, ...] (length 9)
fun! Pattern_ScriptFunPrefixed(prefixpat) abort
    return '\V\C\^\s\*fu\%[nction]!\=\s\+s:\('.a:prefixpat.'\(\S\*\)\)\s\*('
endf

" TODO: !performance caching
fun! Fileparser(file) abort
    return g:Fileparser.inst(a:file)
endf
let g:Fileparser = Object.fork_named('Fileparser')
            \.pushMethodInjector(InjectorPrefixed(s:k_oo_snr, 'Fileparser'))
            \.method('linematches')
            \.method('getLines')
            \.method('__init__')

fun! s:Fileparser_linematches(pat, ...) abort dict
    let cutoff = get(a:, 1, 9)
    if has_key(self.cache, a:pat)
        return map(copy(self.cache[a:pat]), { i,r -> r[:cutoff-1] })
    endif
    let lines = self.getLines()
    if len(lines) > 10
    endif
    let matches =  map(filter(map(lines, { i,l -> matchlist(l, a:pat)}), { i,l -> len(l) > 0}), {i, l -> l[1:]})
    let uniqd = uniq(sort(copy(matches)))
    let self.cache[a:pat] = uniqd
    return map(copy(uniqd), { i,r -> r[:cutoff-1] })
endf
fun! s:Fileparser___init__(file) abort dict
    let self.file = a:file
    let self.cache = {}
endf
fun! s:Fileparser_getLines() abort dict
    if !exists('self.lines')
        let self.lines = readfile(self.file)
    else
    endif
    return self.lines
endf

" TODO: weed out default / lingering injectors
" generic injectors: should have a concrete injector that is called once.
" script-link: should happen at factory level with fullblown snr, parser, ..
" attrs, but script-methods may abstract that away later

let s:bs_script_path = expand('<sfile>:p')
let s:bs_script_parser = Fileparser(s:bs_script_path)
let s:bs_injectorParsingMethods = InjectorParsingMethods('Script_', s:bs_script_path, s:bs_script_parser)


fun! Script(...) abort
    return call(g:ScriptT.inst, a:000)
endf
let g:ScriptT = Object.fork_named("Script").inject(s:b_injector, '__init__', 'Script___init__')
" let g:ScriptT = Object.fork_named("Script")
                " \.inject(s:bs_injectorParsingMethods)


    fun! s:Script___init__(path, ...) abort dict
        let self.path = a:path
        let self.verbosity = get(a:, 1, 0)
        let self.parser = Fileparser(self.path)
    endf 

    fun! s:Script_log(...) abort dict
        return call('lh#log#this', a:000)
    endf
    fun! s:Script_logV(...) abort dict
        if self.verbose
            return call(self.log, a:000)
        endif
        return call('lh#log#this', a:000)
    endf
    fun! s:Script_verbosity(...) abort dict
        let self.verbosity = get(a:, 1, 1)
    endf

    fun! s:Script_newClass(name, minject, ainject) abort dict
        return new 
    endf


    fun! s:Script_sClassBuilder(name, ...) abort dict
        let baseclass = get(a:, 1, Object)
        let factory = get(a:, 1, baseclass.fork_named(a:name))
        return factory.fork_named(a:name).pushMethodInjector(self.sInjector)
    endf
    fun! s:Script_sClassBuilderPrefixed(name, ...) abort dict
        let baseclass = get(a:, 1, Object)
        let factory = get(a:, 1, baseclass.forkNamed(a:name))
        return factory.fork_named(a:name).pushMethodInjector(self.injPrefixed(a:name))
    endf
    fun! s:Script_sClassBuilderParsing(name, ...) abort dict
        let baseclass = get(a:, 1, Object)
        let factory = get(a:, 1, baseclass.forkNamed(a:name))
        return factory.fork_named(a:name).pushMethodInjector(self.sInjectorParsing(a:name))
    endf

let s:script = Script(expand("<sfile>:p"))
" echon s:script.pprint_all()
" echon Dict_pprint(s:script._methods())
" echon s:script.pprint_all()
" echon s:script.pprint()

" echom LHStr(s:script.parser.linematches(Pattern_ScriptVarPrefixed('scr'), 2))
" echom LHStr(s:script.parser.linematches(Pattern_ScriptVarPrefixed('Script_'), 2))


" echom LHStr( map(filter(map(x, { i,l -> matchlist(l, s:extractSFunNames('Script_'))}), { i,l -> len(l) > 1}), {i, l -> l[1]}) )
" echom LHStr(map(x, { i,l -> matchlist(l, s:extractSFunNames('Script_'))}), { i,l -> len(l) > 0})
" echom LHStr(s:script._methods())
" echon s:script.pprint_all()
