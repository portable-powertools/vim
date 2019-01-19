call g:SetConfigVal('adhocinitfile', '', 'MOD_VIM_ADHOC_INITFILE', 0)
call g:SetConfigVal('adhocrtp', '', 'MOD_VIM_ADHOC_RTP', 0)

call g:SetConfigVal('vimunmanageddir', g:vimcfgdir.'/../unmanaged', 'MOD_VIM_UNMANAGED', 1)
call g:SetConfigVal('vimheavystorage', g:vimunmanageddir, 'TS_HEAVY_UNMANAGED', 0)

call g:SetConfigVal('vimplugindir', g:vimcfgdir.'/../vim-plugins', 'MOD_VIMPLUGINS', 1)
call g:SetConfigVal('vimplug', g:vimcfgdir.'/autoload/plug.vim', '', 0)

call g:SetConfigVal('forceGlobalPluginBehavior', 0, 'VIM_FORCE_GLOBAL_CONTEXT', 0)

" call g:SetConfigVal('fzfdir', '', 'mod_fzf_root', 1)
let g:fzfdir='/home/simon/touchstone/modules/fzf/fzf'

