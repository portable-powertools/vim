let g:pdf_convert_on_edit = 1
let g:pdf_convert_on_read = 1
let g:pdf_pdftotext_args = ''

fun! g:PdfEdited(pdffile) abort
    let bnr = bufnr(a:pdffile)
    let b:pdf_origfile=fnamemodify(a:pdffile, ':p')

    if bnr > -1
        exec 'bd '.bnr
    endif
    let g:pdf_pagenr_inc=0
    if stridx(join(getbufline(bufnr('%'), 1, '$'), ''), '') > -1
        exec "normal! ggO\<C-R>=g:PdfPageMarker()\<CR>"
        exec '%s//\=g:PdfPageMarker()/'
    endif
    if match(getline(1), '\V\^/* PAGE') > -1 && &fdm ==# 'manual'
        set fdm=marker
    endif

    exec 'lcd '.fnamemodify(b:pdf_origfile, ':p:h')
    nmap <buffer> - :exec 'e '.fnamemodify(b:pdf_origfile, ':p:h')<CR>
    nmap <buffer> <Leader><c-m> :exec 'Launch evince -i '.PdfPageNr().' '.b:pdf_origfile<CR>
    nmap <buffer> <Leader><c-w> :exec 'Launch evince -i '.PdfPageNr().' '.b:pdf_origfile .' --find="<C-r><c-w>"'<CR>
    nmap <buffer> <Leader><c-l> :exec 'Launch evince -i '.PdfPageNr().' '.b:pdf_origfile .' --find="'.trim(getline('.')).'"'<CR>
    vmap <buffer> <Leader><c-w> :<C-u>exec 'Launch evince -i '.PdfPageNr().' '.b:pdf_origfile . ' --find=".trim(g:GVS())."'<CR>
endf
fun! PdfPageNr() abort
    let pat='\V/* PAGE \zs\d\+'
    let linenr = line('.')
    let lines = getline(max([1,linenr-800]), linenr)
    call map(lines, {i,line -> lh#string#matches(line, pat)})
    call filter(lines, {i,line -> !empty(line) })
    if !empty(lines)
        return lines[-1][0]
    else
        return 1
    endif
endf
fun! g:PdfPageMarker() abort
    let g:pdf_pagenr_inc+=1
    return lh#fmt#printf('/* PAGE %1 {{{1 */', g:pdf_pagenr_inc)."\n"
endf

let g:pdf_hooks = {'on_edited' : function('g:PdfEdited')}

command! -nargs=0 PdfView execute 'Viewer '.b:pdf_origfile

