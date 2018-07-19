export MOD_VIM_SW="$mod_vim_root/vim"
export MOD_VIM_UNMANAGED="$mod_vim_root/unmanaged"  # used by vim
export MOD_VIM_CONFIG="$mod_vim_root/vim-config"

#TODO: vim plugin location and modularity
export MOD_VIMPLUGINS="$mod_vim_root/vim-plugins"  # used by vim

export MYVIMRC="$mod_vim_config/vimrc"
export VIMINIT='source $MYVIMRC'

PATH_add "$mod_vim_installprefix/bin"

export MOD_FZF_SW="$mod_fzf_sw"

#TODO: vim: config dir into module def.
