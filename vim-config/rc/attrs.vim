let s:script = Script(expand('<sfile>:p'))
" Abstract: a class is an attr class by virtue of its attrs specifications.
" These in turn are a member array of spec objects called __attributes__
" a class is "attributized" by setting its initializator to Attrs__init__,
" which will do the necessary modifications on initialization.
" For this purpose, let a class have it's members have normal spec values. to
" be gathered and converted later to the internal __attributes__
" representation.
" Attributization: happens through the injection of init (and maybe, later
" other methods that have a similar special role)
" This injection of __init__ happends with a simple ClassBuilder.inject(AttrsInjector(...)) call. 
" If this is overridden, the class ceases to be an attrs class, but that's
" what you get ignoring the doc. You will aleays be able to call Attrs__init__
" as dictionary method on yourself.

let g:Attrib = s:script.sClassBuilderPrefixed("Attrib")
            \.method(hasDefault)

fun! AttrsInjector() abort
    return Object.fork_named('AttrInjector').pushMethodInjector(InjectorPrefixed('s:k_oo_snr', 'AttrInjector'))
                \.method('inject')
                \.method('finish')
                \.method()
endf

fun! s:AttrsInjector_inject(object, name, ...) abort dict
    let options = get(a:, 1, {})
    let o = a:object
    if !has_key(o, '__attributes__')
        let o.__attributes__ = []
    endif
    call add(o.__attributes__, [a:name, options])
endf
fun! s:AttrsInjector_finish(object, injectionArgs) abort dict
    if exists(object.__attributes__) && !empty(object.__attributes__)
    endif
endf
fun! s:Attrs__init__(...) abort dict
    let args = copy(a:000)
    let attrs = object.__attributes__
    let attrsIdx = -1

    let l:defaultargEncountered = 0
    let l:runOutOfArgs = 0

    if len(args) > len(attrs)
        throw "VimAttrs __init__: more args than attrs!"
    endif
    for a in attrs
        let attrsIdx += 1
        if len(args) <= attrsIdx
            let l:runOutOfArgs = 1
        endif
        
        let arg = args[i]
        let [name, options] = attrs[argsIdx]
        call lh#assert#type(options).is({})

        if l:runOutOfArgs
            if !exists(l:default)
                throw lh#fmt#printf("VimAttrs __init__: (attr: %1) was not specified", name)
            else
    
            endif
        endif
        
        unlet l:default
    endfor

    for [name,options] in object.__attributes__
        

    endfor
endf

class AttrSpec
fun! s:getDefault(attrOptions) abort
    let options = attrOptions
    
    for [k,V] in items(options)
        let init = 1

        if len(args) > argsIdx
            " gotta rely on defaults
            
        endif

        if k ==# 'factory'
            if exists('l:default')
                throw lh#fmt#printf("VimAttrs __init__: (attr: %1) both default and factory specified", name)
            endif
            if V == '{}'
                let l:default = {}
            elseif V == '[]'
                let l:default = []
            elseif type(V) == 2 " funcref
                let l:default = call(V, [])
            elseif type(V) == type([])
                call lh#assert#not_empty(V)
                if type(V[0] == type([]) && len(V) == 2 && type(V[1]) == type([])
                    let bindargs = V[0]
                    let execargs = V[1]
                else
                    let bindargs = V
                    let execargs = []
                endif
                let l:default = call('lh#function#execute', [ call('lh#function#bind', bindargs) ] + execargs)
            else
                throw "VimAttrs: don't know how to handle factory spec ". string(V)
            endif

        elseif k ==# 'default'
            let l:default = V

        elseif k ==# 'init'
            let init = V

        endif

    endfor
    if exists('l:default')
        return l:default
    endif
    throw lh#fmt#printf("VimAttrs __init__: tried to retrieve default but attr doesnt seem to have one (internal error)")
endf

