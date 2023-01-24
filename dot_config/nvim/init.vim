" ======================
"  Plugin
" ======================
call plug#begin('~/.vim/plugged')

" Edit 
Plug 'easymotion/vim-easymotion'
Plug 'ervandew/supertab'
Plug 'junegunn/vim-easy-align'
Plug 'machakann/vim-highlightedyank'
Plug 'scrooloose/nerdcommenter'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-surround'

" Display
Plug 'romainl/vim-dichromatic'
Plug 'itchyny/lightline.vim'
Plug 'patstockwell/vim-monokai-tasty'
Plug 'phanviet/vim-monokai-pro'

" Language supports
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'udalov/kotlin-vim'

" Tool integrations
Plug 'iberianpig/tig-explorer.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" File Managers
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" Terminal
Plug 'voldikss/vim-floaterm'

" Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

call plug#end()


" ======================
"  Display
" ======================

syntax enable
filetype on
set termguicolors
let g:vim_monokai_tasty_italic = 1
colorscheme dichromatic
let g:lightline = {
      \ 'colorscheme': 'vim-dichromatic',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

highlight GitGutterAdd ctermfg=green
highlight GitGutterChange ctermfg=blue
highlight GitGutterDelete ctermfg=red
highlight! link SignColumn LineNr

" ======================
"  Editor
" ======================
set autoread
set clipboard=unnamed
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



" completion popup
set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
noremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'


" ======================
"  Plugin Config
" ======================


" highlightedyank
if !exists('##TextYankPost')
  map y <Plug>(highlightedyank)
endif


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

" fzf
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'border': 'sharp' } }
nnoremap <silent> <leader>p :Files<CR>
