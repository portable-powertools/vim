if empty(glob(g:vimplug))
  execute 'silent !curl -fLo "' . g:vimplug' . '" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
