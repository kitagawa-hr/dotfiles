
" File encoding
if !exists ('g:encoding_set') || !has('nvim')
    set encoding=utf-8
    set fileencodings=utf-8,sjis,iso-2022-jp,cp932,euc-jp
    set fileencoding=utf-8
    let g:encoding_set=1
endif
scriptencoding utf-8

" Don't create swp file
set writebackup
set nobackup
set noswapfile
set noundofile

" set modifiable
" set write

" Show column number
set number
set relativenumber

" Long text
set wrap
set textwidth=0
set colorcolumn=256

" Highlight cursor line
" set cursorline

" Invisible stirng
set list
set listchars=tab:»-,extends:»,precedes:«,nbsp:%,eol:$,trail:~

" Don't unload buffer when it is abandones
set hidden

" New load buffer is use open
set switchbuf=useopen

" Smart insert tab setting.
set smarttab

" Excahnge tab to space.
set expandtab

" Auto insert indent.
set autoindent

" Round indent by shiftwidth.
set shiftwidth=4

" Round indent to multipul of shiftwidth
set shiftround

" Space insert by autoindent
set tabstop=4
set scrolloff=15

" Splitting a window will put the new window below the current one.
set splitbelow
" Splitting a window will put the new window right the current one.
set splitright
" Set minimal width for current window.
set winwidth=30
" Set minimal height for current window.
set winheight=1
" Set maximam maximam command line window.
set cmdwinheight=5
" No equal window size.
set noequalalways
" Adjust window size of preview and help.
set previewheight=8
set helpheight=12

" show tab line
set showtabline=2

" Ignore case is search patterns
set ignorecase

" No ignore case when pattern has uppercase
set smartcase

" Search is incremental search
set incsearch

" Replace incremental
if exists('&inccommand')
  set inccommand=split
endif

" Show search result highlight
set hlsearch

" Share clipborad with system
set clipboard+=unnamedplus

" Use extend grep
if executable('rg')
    let &grepprg = 'rg --vimgrep --hidden'
    set grepformat=%f:%l:%c:%m
elseif executable('pt')
    let &grepprg = 'pt --nocolor --nogroup --column'
    set grepformat=%f:%l:%c:%m
endif

" Show quickfix after grepcmd
augroup GrepCmd
    autocmd!
    autocmd QuickFixCmdPost vim,grep,make if len(getqflist()) != 0 | cwindow | endif
augroup END

" For input multibyte chars
set ttimeout
set ttimeoutlen=50

" Save undo history
if has('persistent_undo')
  set undodir=./.vimundo,~/.vimundo
  augroup vimrc-undofile
    autocmd!
    autocmd BufReadPre ~/* setlocal undofile
  augroup END
endif

" jq command
command! -nargs=? Jq call s:Jq(<f-args>)
function! s:Jq(...)
    if 0 == a:0
        let l:arg = "."
    else
        let l:arg = a:1
    endif
    execute "%! jq \"" . l:arg . "\""
endfunction

" Number of characters to apply syntax per line
set synmaxcol=512

" Reload change file
augroup vimrc-checktime
  autocmd!
  autocmd WinEnter * checktime
augroup END

" Disable sql omni complete
let g:omni_sql_no_default_maps = 1

" IME control for fcitx
if has('unix') && executable('fcitx-remote')
    let g:input_toggle = 0

    function! Fcitx2en()
        let s:input_status = system("fcitx-remote")
        if s:input_status == 2
            let g:input_toggle = 1
            let l:a = system("fcitx-remote -c")
        endif
    endfunction

    function! Fcitx2zh()
        let s:input_status = system("fcitx-remote")
        if s:input_status != 2 && g:input_toggle == 1
            let l:a = system("fcitx-remote -o")
            let g:input_toggle = 0
        endif
    endfunction

    augroup FixtxIMEControl
        autocmd!
        "Leave Insert mode
        autocmd InsertLeave * call Fcitx2en()
        "Enter Insert mode
        autocmd InsertEnter * call Fcitx2zh()
    augroup END
endif
