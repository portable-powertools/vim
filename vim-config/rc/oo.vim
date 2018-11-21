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
    let attributes = filter(copy(cp), { i,v -> type(v) != funtype })
    return attributes
endf
fun! Dict_pprint(dict) abort
    let pretty = "{\n"
    for [k,V] in items(a:dict)
        let pretty = pretty . printf("\t%s\t -> %s\n", k, V)
    endfor
    let pretty .=  "}"
    return pretty
endf

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
    let s.defaultMethodInjector = {}
    let s.defaultAttrInjector = InjectorAttrDefault()
    let s.injections = []
    let s.names = lh#stack#new(['root'])

    call s:b_injector.inject(s, '_to_string', 'ClassFactory_tostring')
    call s:b_injector.inject(s, 'pprint', 'ClassFactory_pprint')
    call s:b_injector.inject(s, 'getName', 'ClassFactory_getName')
    
    call s:b_injector.inject(s, 'allocProto', 'ClassFactory_allocProto')

    " Immutable_Interface:
    call s:b_injector.inject(s, 'fork', 'ClassFactory_fork') " returns an independent instance of this factory
    call s:b_injector.inject(s, 'inst', 'ClassFactory_constructor') " constructs the object
    call s:b_injector.inject(s, 'dict', 'ClassFactory_dict_constructor')
    call s:b_injector.inject(s, 'push_name', 'ClassFactory_push_name')

    call s:b_injector.inject(s, 'withMethodInjector', 'ClassFactory_withMethodInjector')
    call s:b_injector.inject(s, 'withAttrInjector', 'ClassFactory_withAttrInjector')

    " Factory_interface:
    " many more possible, let's rely on default-injector methods and default-valued fields
    call s:b_injector.inject(s, 'inject', 'ClassFactory_inject')
    call s:b_injector.inject(s, 'attr', 'ClassFactory_add_default_valued_attr')
    call s:b_injector.inject(s, 'method', 'ClassFactory_add_default_script_method')

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
    fun! s:ClassFactory_push_name(name) abort dict
        call self.names.push(a:name)
        return self
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
        for [injector, payload] in self.injections
            call call(injector.inject, [alloc] + payload)
        endfor
        return alloc
    endf

    " Public_immutable_interface:
    fun! s:ClassFactory_fork() abort dict
        let alloc = copy(self)
        let alloc.injections = copy(self.injections)
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
        let alloc.__class__ = self.fork()
        return alloc
    endf

    "Builder: interface

    fun! s:ClassFactory_withAttrInjector(injector) abort dict
        let self.defaultAttrInjector = a:injector
        return self
    endf
    fun! s:ClassFactory_withMethodInjector(injector) abort dict
        let self.defaultMethodInjector = a:injector
        return self
    endf
    
    fun! s:ClassFactory_inject(injector, ...) abort dict
        call add(self.injections, [a:injector, a:000])
        return self
    endf
    fun! s:ClassFactory_add_default_valued_attr(...) abort dict
        call lh#assert#not_empty(self.defaultAttrInjector)
        call call(self.inject, [self.defaultAttrInjector] + a:000 )
        return self
    endf
    fun! s:ClassFactory_add_default_script_method(...) abort dict
        call lh#assert#not_empty(self.defaultMethodInjector)
        call call(self.inject, [self.defaultMethodInjector] + a:000 )
        return self
    endf



function! InjectorAttrDefault()
    let s = lh#object#make_top_type({})
    let s.prtfmt = 'attr: "%1", default: %2'
    call lh#object#inject(s, 'inject', 'InjectorAttrDefault_inject', s:k_oo_snr)
    return s
endfun
    " This could be extended up to attr.s dimensions, automatically building the initializer etc
    fun! s:InjectorAttrDefault_inject(object, key, value) abort dict
        call lh#assert#type(a:key).is('string')
        "TODOitclean: log warning when overwriting
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


" This is a class! call 'inst()' or 'dict()' on it to get an object
fun! ObjectClassFactory() abort
    let factory = ClassFactory()
    let factory.defaultMethodInjector = s:b_injector

    let factory = factory
                \.method('_to_string',      'Object_tostring')
                \.method('pprint',          'Object_pprint')
                \.method('set',             'Object_set')
                \.method('inject',          'Object_monkeypatch')
    return factory
endf
    fun! s:Object_set(name, value) abort dict
        let self.obj[a:name] = a:value
        return self
    endf
    fun! s:Object_monkeypatch(mname, mscriptname) abort dict
        call self.__class__.defaultMethodInjector.inject(self, a:mname, a:mscriptname)
        return self
    endf
    fun! s:Object_tostring(...) abort dict
        return lh#object#_to_string(FilterClassMembers(cp, '^_'), get(a:, 1, []))
    endf
    fun! s:Object_pprint() abort dict
        return Dict_pprint(FilterClassMembers(self, '^_'))
    endf


let s:ObjectT = ObjectClassFactory()
let s:ObjectT.names.values = ["Object"]
fun! Object() abort
    return s:ObjectT.fork()
endf

" let s:Scriptcache = Object().push_name('Scriptcache')
"             \.attr('cache', j)

    
"     fun! Scriptcache_extractPrefixedSFun(scriptpath, prefix)
"         let content = readfile(a:scriptpath)
"         return map(filter(map(a:content, { i,l -> matchlist(l, s:extractSFunNames(a:prefix))}), { i,l -> len(l) > 1}), {i, l -> l[1]})
"     endf

" TODO: IMPORTANT: beware of non-factory default {} and []
" TODO: IMPORTANT: beware of non-factory default {} and []
" TODO: IMPORTANT: beware of non-factory default {} and []
" TODO: IMPORTANT: beware of non-factory default {} and []
" TODO: IMPORTANT: beware of non-factory default {} and []
" TODO: IMPORTANT: beware of non-factory default {} and []
" TODO: IMPORTANT: beware of non-factory default {} and []

" instantiate a Script instance with Script().inst('<sname>:p') 
fun! Script() abort
    return s:ScriptT.fork()
endf
let s:ScriptT = Object()
                \.push_name("Script")
                \.withMethodInjector(InjectorPrefixed(s:k_oo_snr, 'Script'))
                \.method('log')
                \.method('logV')
                \.method('verbosity')
                \.method('sInjector')
                \.method('sInjectorPrefixed')
                \.method('sClassBuilder')
                \.method('sClassBuilderPrefixed')
                \.attr('path', '')
                \.attr('_parsing_cache', {})
                \.attr('verbosity', 0)
                \.inject(s:b_injector, '__init__', 'Script_init')

    

    fun! s:Script_init(path) abort dict
        let self.path = a:path
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

    fun! s:Script_sInjector() abort dict
        return InjectorSnr(self.path)
    endf
    fun! s:Script_sInjectorPrefixed(prefix) abort dict
        return InjectorPrefixed(self.path, a:prefix)
    endf
    fun! s:Script_sInjectorParsing(prefix, script) abort dict
        return InjectorParsing(self.path, a:prefix)
    endf

    fun! s:Script_sClassBuilder(name) abort dict
        let factory = get(a:, 1, Object())
        return factory.push_name(a:name).withMethodInjector(self.sInjector())
    endf
    fun! s:Script_sClassBuilderPrefixed(name) abort dict
        let factory = get(a:, 1, Object())
        return factory.push_name(a:name).withMethodInjector(self.sInjectorPrefixed(a:name))
    endf

let s:script = Script().inst(expand("<sfile>:p"))

let x = readfile(s:script.path)
fun! s:extractSFunNames(prefixpat) abort
    return '\V\C\^\s\*fu\%[nction]!\=\s\+\%(s:\)\('.a:prefixpat.'\.\*\)\s\*('
endf

echom LHStr( map(filter(map(x, { i,l -> matchlist(l, s:extractSFunNames('Script_'))}), { i,l -> len(l) > 1}), {i, l -> l[1]}) )
" echom LHStr(map(x, { i,l -> matchlist(l, s:extractSFunNames('Script_'))}), { i,l -> len(l) > 0})
