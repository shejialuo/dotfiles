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
git pill origin master

# vim-which-key
cd ~/.vim/pack/interface/start/vim-which-key
git pull origin master

# coc.vim
cd ~/.vim/pack/coc/start/coc.nvim
git pull origin master

vim -c "CocUpdate coc-snippets coc-pairs coc-lists coc-explorer coc-diagnostic coc-webview coc-markdown-preview-enhanced coc-yank coc-spell-checker" -c "q"

vim -c "CocUpdate coc-sh coc-css coc-html coc-json coc-tsserver coc-markdownlint coc-pyright coc-clangd coc-angular coc-go coc-yaml " -c "q"

# nerdcommenter
cd ~/.vim/pack/tool/start/nerdcommenter
git pull origin master

# vim-visual-multi
cd ~/.vim/pack/tool/start/vim-visual-multi
git pull origin master
