" setting
" dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

set noswapfile
set hidden
set showcmd
set number
set smartindent
set autoindent
set showmatch
set laststatus=2
set mouse=

nnoremap j gj
nnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk

inoremap jj <ESC>

set hlsearch
nnoremap <Esc><Esc> :<C-u>set nohlsearch<Return>
nnoremap / :<C-u>set hlsearch<Return>/
nnoremap ? :<C-u>set hlsearch<Return>?
nnoremap * :<C-u>set hlsearch<Return>*
nnoremap # :<C-u>set hlsearch<Return>#

let mapleader = ","

set smarttab
set expandtab
set tabstop=2
set shiftwidth=2

set ignorecase
set smartcase
set wrapscan

set sh=/bin/bash
tnoremap <silent> <ESC> <C-\><C-n>

if has('persistent_undo')
  set undodir=~/.vim/undo
  set undofile
endif

set noshowmode
syntax on

filetype plugin indent on
syntax enable

let g:python3_host_prog = $PYENV_ROOT . '/shims/python3'

" プラグインがインストールされるディレクトリ
let s:dein_dir = expand('~/.cache/dein')
" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vim がなければ github から落としてくる
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" 設定開始
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイルを用意しておく
  let g:rc_dir    = expand("~/.config/nvim/")
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " 設定終了
  call dein#end()
  call dein#save_state()
endif

" もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif

