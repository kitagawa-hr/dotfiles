" 使用するpythonインタプリタ
g:python_host_pro='/Users/kitagawaharuki/.pyenv/versions/neovim/bin/python'
g:python_host_pro='/Users/kitagawaharuki/.pyenv/versions/3.6.5/bin/python'
set mouse=a
set clipboard+=unnamedplus
" reset augroup
augroup MyAutoCmd
     autocmd!
augroup END

" ENV
let $CACHE = empty($XDG_CACHE_HOME) ? expand('$HOME/.cache'): $XDG_CACHE_HOME
let $CONFIG = empty($XDG_CONFIG_HOME) ? expand('$HOME/.config') : $XDG_CONFIG_HOME
let $DATA = empty($XDG_DATA_HOME) ? expand('$HOME/.local/share') : $XDG_DATA_HOME

" Load rc file
function! s:load(file) abort
	let s:path = expand('$CONFIG/nvim/rc/' . a:file . '.vim')

	if filereadable(s:path)
		execute 'source' fnameescape(s:path)
	endif
endfunction

                         call s:load('plugins')
" プラグインが実際にインストールされるディレクトリ
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

if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)
    call dein#load_toml('~/.vim/rc/dein.toml',          {'lazy': 0})
    call dein#load_toml('~/.vim/rc/dein_lazy.toml',     {'lazy': 1})
    call dein#load_toml('~/.vim/rc/dein_neo.toml',      {'lazy': 1})
    call dein#load_toml('~/.vim/rc/dein_python.toml',   {'lazy': 1})
    call dein#load_toml('~/.vim/rc/dein_frontend.toml', {'lazy': 1})
    call dein#end()
    call dein#save_state()
endif
