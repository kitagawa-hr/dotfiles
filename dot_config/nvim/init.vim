call plug#begin('~/.vim/plugged')

Plug 'easymotion/vim-easymotion'
Plug 'endel/vim-github-colorscheme'
Plug 'ervandew/supertab'
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
Plug 'iberianpig/tig-explorer.vim'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/vim-easy-align'
Plug 'machakann/vim-highlightedyank'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'patstockwell/vim-monokai-tasty'
Plug 'phanviet/vim-monokai-pro'
Plug 'rbgrouleff/bclose.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-surround'
Plug 'udalov/kotlin-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ymyzk/vim-copl'

call plug#end()

if !exists('##TextYankPost')
  map y <Plug>(highlightedyank)
endif

" completion popup
set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
noremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

" NERDTree
let g:NERDTreeShowBookmarks = 1
let NERDTreeQuitOnOpen = 1
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
nnoremap <Leader>f :NERDTreeToggle<Enter>

" NERDCommenter
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1

" tig-explorer
nnoremap <Leader><Leader>t :TigOpenProjectRootDir<CR>

set clipboard=unnamed
syntax enable
filetype on
set termguicolors
let g:vim_monokai_tasty_italic = 1
colorscheme vim-monokai-tasty
let g:lightline = {
      \ 'colorscheme': 'monokai_tasty',
      \ }
let g:airline_theme='monokai_tasty'

set autoread
set cursorcolumn
set cursorline
set expandtab
set fenc=utf-8
set hidden
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set list listchars=tab:\▸\-
set nobackup
set nocompatible
set noswapfile
set number
set shiftwidth=2
set showcmd
set showmatch
set smartcase
set smartindent
set tabstop=2
set virtualedit=onemore
set visualbell
set wildmode=list:longest
set wrapscan



" firenvim
if exists('g:started_by_firenvim')
  " remove status bar
  set laststatus=0 ruler
  " remove EOL characters
  set lcs=tab:>-,trail:.,extends:»,precedes:«

  let g:firenvim_config = {
  \   'globalSettings': {
  \     'alt': 'all',
  \    },
  \   'localSettings': {
  \     '.*': {
  \       'cmdline': 'firenvim',
  \       'priority': 0,
  \       'selector': 'textarea',
  \       'takeover': 'never',
  \     },
  \   }
  \ }

  set guifont=Fira\ Code:h10

  " site specific filetype
  augroup Firenvim
    au BufEnter github.com_*.txt set filetype=markdown
    au BufEnter *ipynb_*.txt set filetype=python
    au BufEnter *cloud.google.com_bigquery_*.txt set filetype=sql
  augroup END
endif

