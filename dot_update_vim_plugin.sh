#!/bin/bash

# Dracula Theme
cd ~/.vim/pack/themes/start/dracula
git pull origin master

# vim-airline
cd ~/.vim/pack/interface/start/vim-airline
git pull origin master

# vim-airline-theme
cd ~/.vim/pack/interface/start/vim-airline-themes
git pull origin master

# vim-fugitive
cd ~/.vim/pack/integration/start/vim-fugitive
git pull origin master

# vim-gitgutter
cd ~/.vim/pack/integration/start/vim-gitgutter
git pull origin master

# vim-which-key
cd ~/.vim/pack/interface/start/vim-which-key
git pull origin master

# coc.vim
cd ~/.vim/pack/coc/start/coc.nvim
git pull origin master

vim -c "CocUpdate"

# nerdcommenter
cd ~/.vim/pack/tool/start/nerdcommenter
git pull origin master

# vim-visual-multi
cd ~/.vim/pack/tool/start/vim-visual-multi
git pull origin master

# vim-wakatime
cd ~/.vim/pack/tool/start/vim-wakatime
git pull origin master

# asyncrun.vim
cd ~/.vim/pack/tool/start/asyncrun.vim
git pull origin master

# asynctasks.vim
cd ~/.vim/pack/tool/start/asynctasks.vim
git pull origin master

