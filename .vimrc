﻿scriptencoding utf-8
set encoding=utf8
set fileencodings=ucs-bom,iso-2022-jp-3,euc-jisx0213,euc-jp,cp932,utf-8
" -------------------------------------------------------------------------
" AutoCommandGroup
" -------------------------------------------------------------------------
filetype off
let mapleader="\<Space>"
autocmd QuickFixCmdPost *grep* cwindow
" -------------------------------------------------------------------------
" Plugins
" -------------------------------------------------------------------------
function! InstallVimPlug(plug_dir)
	call mkdir(a:plug_dir, 'p')
	call system('git clone https://github.com/junegunn/vim-plug.git ' . a:plug_dir . '/autoload')
endfunction
command! InstallVimPlug call InstallVimPlug(expand('~/vim-plug'))
if has('vim_starting')
	set runtimepath^=~/vim-plug
endif
let g:plug_url_format='https://github.com/%s.git'
filetype plugin indent off
syntax off
call plug#begin('~/vim-plug')
Plug 'junegunn/vim-plug', {'dir': '~/vim-plug/autoload'}
Plug 'Shougo/unite.vim'
Plug 'Shougo/neomru.vim'
Plug 'tyru/open-browser.vim'
Plug 'scrooloose/syntastic'
Plug 'vim-scripts/DoxygenToolkit.vim'
Plug 'thinca/vim-fontzoom'
Plug 'beyondmarc/hlsl.vim'
Plug 'vim-scripts/Tagbar'
Plug 'cohama/agit.vim'
Plug 'tpope/vim-fugitive'
Plug 'kana/vim-altr'
Plug 'Valloric/YouCompleteMe'
Plug 'flazz/vim-colorschemes'
Plug 'nagaohiroki/myplugin.vim'
Plug 'godlygeek/tabular'
call plug#end()
filetype plugin indent on
syntax on
set background=dark
colorscheme iceberg
" --------------------------------------------------------------------------
" Tagbar
" --------------------------------------------------------------------------
nnoremap <Leader>t :TagbarToggle<CR>
let g:tagbar_sort=0
let g:tagbar_left=1
" --------------------------------------------------------------------------
" open-browser
" --------------------------------------------------------------------------
nmap <Leader>o <Plug>(openbrowser-smart-search)
" ----------------------------------------------------------------------
" artr
" ---------------------------------------------------------------------
nmap <Leader>h <Plug>(altr-forward)
" --------------------------------------------------------------------------
" syntastic
" --------------------------------------------------------------------------
let g:syntastic_cs_checkers=['syntax', 'semantic', 'issues']
let g:syntastic_python_checkers=['flake8']
let g:syntastic_go_checkers=['go', 'gofmt', 'golint', 'govet']
" --------------------------------------------------------------------------
" omnisharp
" --------------------------------------------------------------------------
function! CopyOmnisharpConfig()
	let dst=expand('~/dotfiles/setup/config.json')
	let src=expand('~/vim-plug/YouCompleteMe/third_party/ycmd/third_party/OmniSharpServer/OmniSharp/bin/Release/config.json')
	echo system(has('win32') ? 'copy' : 'cp' . ' "' . src . '" "' . dst . '"')
endfunction
command! CopyOmnisharpConfig call CopyOmnisharpConfig()
nnoremap <Leader>g :YcmCompleter GoToDefinition<CR>
" -------------------------------------------------------------------------
" youcompleteme(cpp)
" -------------------------------------------------------------------------
let g:ycm_global_ycm_extra_conf='~/dotfiles/.ycm_extra_conf.py'
" -------------------------------------------------------------------------
" unite
" -------------------------------------------------------------------------
call unite#custom#source('file_mru,file,file_rec', 'ignore_pattern', '\.meta$' )
nnoremap <Leader>f :Unite -start-insert file -path=<C-R>=fnameescape(expand('%:p:h'))<CR><CR>
nnoremap <Leader>m :Unite -start-insert file_mru<CR>
" --------------------------------------------------------------------------
" DoxygenToolkit
" --------------------------------------------------------------------------
let g:DoxygenToolkit_blockHeader=repeat('-', 72)
let g:DoxygenToolkit_blockFooter=g:DoxygenToolkit_blockHeader
let g:DoxygenToolkit_commentType='C++'
" --------------------------------------------------------------------------
" altr for Unreal C++
" --------------------------------------------------------------------------
call altr#define('Private/%.cpp', 'Public/%.h')
" ----------------------------------------------------------------------
" Astyle
" ---------------------------------------------------------------------
function! Astyle()
	let l:pos = getpos('.')
	%!AStyle -I -n -A1 -t -p -D -U -j
	call setpos('.',pos)
endfunction
command! Astyle call Astyle()
" ----------------------------------------------------------------------
" change terminal cursol size
" ---------------------------------------------------------------------
if !has('win32')
	let &t_SI = "\<Esc>]50;CursorShape=1\x7"
	let &t_EI = "\<Esc>]50;CursorShape=0\x7"
	inoremap <Esc> <Esc>
endif
" ----------------------------------------------------------------------
" Utility Command
" ---------------------------------------------------------------------
command! CopyPath call setreg('*', expand('%:p'))
command! DateTime normal i<C-R>=strftime("%Y/%m/%d %H:%M:%S")<CR>
command! Rc tabe ~/dotfiles/.vimrc
command! RcUpdate source ~/dotfiles/.vimrc | YcmRestartServer
if has('win32')
	command! Term silent !start cmd /k cd /d "%:p:h"
	command! Wex silent !start explorer /select,"%:p"
	vnoremap <Leader>x y:silent !start "<C-R>0"<CR>
endif
if has('mac')
	command! Term silent !open -a iTerm "%:p:h"
	command! Wex silent !open "%:p:h"
	vnoremap <Leader>x y:silent !open "<C-R>0"<CR>
endif
" --------------------------------------------------------------------------
" Setting
" --------------------------------------------------------------------------
set autoindent
set autoread
set clipboard=unnamedplus,unnamed
set helplang=ja
set hidden
set hlsearch
set incsearch
set laststatus=2
set list
set listchars=eol:<,tab:>\ ,extends:<
set number
set noshowmatch
set noswapfile
set notimeout
set nowrap
set nrformats=hex
set nobackup
set shiftwidth=4
set showcmd
set smartindent
set smartcase
set ignorecase
set tabstop=4
set title
set undolevels=1000
set undodir=$HOME/.cache
set undofile
set whichwrap=b,s,h,l,<,>,[,]
set mouse=a
set visualbell t_vb=
set colorcolumn=80
set tags+=tags;
set statusline=%<%f%m%r%h%w
set statusline+=%y%{'['.&fenc.(&bomb?'_bom':'').']['.&ff.']'}
set statusline+=%=%c,%l/%L
" ----------------------------------------------------------------------
" mapping
" ----------------------------------------------------------------------
inoremap <ESC> <ESC>:set iminsert=0<CR>
nnoremap <S-Left>  :set columns-=100<CR>
nnoremap <S-Right> :set columns+=100<CR>
nnoremap <C-j> :cn<CR>zz
nnoremap <C-k> :cp<CR>zz
nnoremap <C-p> "0p
vnoremap <C-p> "0p
nnoremap <Leader>s :%s/\<<C-R><C-W>\>//g<Left><Left>
