let s:script = Script(expand('<sfile>:p'))
fun! s:Class() abort
    return s:script.objectFactory()
endf

fun! s:xkcd(a) abort dict
    echo string(a:a) . ' on ' . LHStr(self) . '  ' . self.y
endf
echo 'asdfsdfs'
let x = s:Class().smethod('xkcd', 'xkcd').finalize().set('y', 3)
let g:y = s:Class().smethod('xkcd', 'xkcd').finalize().set('y', 3)


call x.xkcd(5)
call g:y.xkcd(2)
call s:script.log('abc %1', 3)
