export mod_vim_root="$(readlink -f "$(bootstrapDir)/..")"

PATH_add "$mod_vim_root/util.bin.d"
PATH_add "$mod_vim_root/.local/bin"

export MOD_VIM_UNMANAGED="$mod_vim_root/unmanaged"  # used by vim
export MOD_VIMPLUGINS="$mod_vim_root/vim-plugins"  # used by vim

export MYVIMRC="$mod_vim_root/vim-config/vimrc"
export VIMINIT='source $MYVIMRC'

export EDITOR=vim
