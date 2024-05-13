#!/bin/bash

# Dracula Theme
mkdir -p ~/.vim/pack/themes/start
cd $_
git clone https://github.com/dracula/vim.git dracula

# vim-airline
mkdir -p ~/.vim/pack/interface/start
cd ~/.vim/pack/interface/start
git clone https://github.com/vim-airline/vim-airline
vim -u NONE -c "helptags  ~/.vim/pack/interface/start/vim-airline/doc" -c "q"

# vim-airline-theme
cd ~/.vim/pack/interface/start
git clone https://github.com/vim-airline/vim-airline-themes
vim -u NONE -c "helptags  ~/.vim/pack/interface/start/vim-airline-themes/doc" -c "q"

# vim-fugitive
mkdir -p ~/.vim/pack/integration/start
cd $_
git clone https://github.com/tpope/vim-fugitive
vim -u NONE -c "helptags  ~/.vim/pack/integration/start/vim-fugitive/doc" -c "q"

# vim-gitgutter
cd ~/.vim/pack/integration/start
git clone https://github.com/airblade/vim-gitgutter
vim -u NONE -c "helptags  ~/.vim/pack/integration/start/vim-gitgutter/doc" -c "q"

# vim-which-key
cd ~/.vim/pack/interface/start
git clone https://github.com/liuchengxu/vim-which-key
vim -u NONE -c "helptags  ~/.vim/pack/interface/start/vim-which-key/doc" -c "q"

# coc.nvim
mkdir -p ~/.vim/pack/coc/start
cd ~/.vim/pack/coc/start
git clone --branch release https://github.com/neoclide/coc.nvim.git --depth=1

vim -c "CocInstall coc-snippets coc-pairs coc-lists coc-explorer coc-diagnostic coc-yank coc-spell-checker" -c "q"

vim -c "CocInstall coc-sh coc-css coc-html coc-json coc-tsserver coc-markdownlint coc-pyright coc-clangd coc-yaml coc-cmake" -c "q"

# nerdcommenter
mkdir -p ~/.vim/pack/tool/start
cd ~/.vim/pack/tool/start
git clone https://github.com/preservim/nerdcommenter
vim -u NONE -c "helptags  ~/.vim/pack/tool/start/nerdcommenter/doc" -c "q"

# vim-wakatime
cd ~/.vim/pack/tool/start
git clone https://github.com/wakatime/vim-wakatime

# vim-polyglot
cd ~/.vim/pack/tool/start
git clone --depth 1 https://github.com/sheerun/vim-polyglot

