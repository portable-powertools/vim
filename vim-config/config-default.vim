call g:SetConfigVal('adhocinitfile', '', 'MOD_VIM_ADHOC_INITFILE', 0)
call g:SetConfigVal('adhocrtp', '', 'MOD_VIM_ADHOC_RTP', 0)

call g:SetConfigVal('vimunmanageddir', g:vimcfgdir.'/unmanaged', 'MOD_VIM_UNMANAGED', 1)
call g:SetConfigVal('vimheavystorage', g:vimcfgdir.'/unmanaged', 'TS_HEAVY_UNMANAGED', 0)

call g:SetConfigVal('vimplugindir', g:vimcfgdir.'/plugged', 'MOD_VIMPLUGINS', 1)
call g:SetConfigVal('vimplug', g:vimcfgdir.'/autoload/plug.vim', '', 0)

call g:SetConfigVal('forceGlobalPluginBehavior', 0, 'VIM_FORCE_GLOBAL_CONTEXT', 0)

call g:SetConfigVal('fzfdir', '', 'MOD_FZF_SW', 1) " TODO: handle that the plugin is not loaded when this is not set

