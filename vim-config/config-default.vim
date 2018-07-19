" - look if previous script already set the value
" - if not, and if specified, look in env. variable
" - use default and possible issue warning
" confer also to support-funcs for the config info flow.
fun! s:SetConfigVal(gName, default, envvarName, warning)
    execute 'let g:'.a:gName.' = g:ConfigVal(a:gName, a:envvarName, a:default, a:warning)'
endf


call s:SetConfigVal('vimunmanageddir', g:vimcfgdir.'/unmanaged', 'MOD_VIM_UNMANAGED', 1)
call s:SetConfigVal('vimheavystorage', g:vimcfgdir.'/unmanaged', 'TS_HEAVY_UNMANAGED', 0)

call s:SetConfigVal('vimplugindir', g:vimcfgdir.'/plugged', 'MOD_VIMPLUGINS', 1)
call s:SetConfigVal('vimplug', g:vimcfgdir.'/autoload/plug.vim', '', 0)

call s:SetConfigVal('forceGlobalPluginBehavior', 0, 'VIM_FORCE_GLOBAL_CONTEXT', 0)

call s:SetConfigVal('fzfdir', '', 'MOD_FZF_SW', 1) " TODO: handle that the plugin is not loaded when this is not set

