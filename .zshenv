#!/usr/local/bin/zsh
# 環境変数
export LANG=ja_JP.UTF-8
export PATH="$HOME/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export EDITOR='nvim'
export XDG_CONFIG_HOME="$HOME/.config"

#自動補間
autoload -U compinit
compinit
# rust
export PATH="${HOME}/.cargo/bin:$PATH"
# nim
export PATH="${HOME}/.nimble/bin:$PATH"
# GO
export GOPATH="${HOME}/go"
export PATH="$GOPATH/bin:$PATH"
# Python
## PYTHONPATH
export PYTHONPATH="${HOME}/da-workflow/src"
export PYTHONPATH="$PYTHONPATH:${HOME}/kenshin_database"
## PIPENV
export PIPENV_VENV_IN_PROJECT=true
## pyenv
export PYENV_ROOT="${HOME}/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
## poetry
export PATH="$HOME/.poetry/bin:$PATH"


###################### History #######################
# 入力したコマンドがすでにコマンド履歴に含まれる場合、履歴から古いほうのコマンドを削除する
# コマンド履歴とは今まで入力したコマンドの一覧のことで、上下キーでたどれる
setopt hist_ignore_all_dups

# コマンドがスペースで始まる場合、コマンド履歴に追加しない
# 例： <Space>echo hello と入力
setopt hist_ignore_space

# <Tab> でパス名の補完候補を選択できる
zstyle ':completion:*:default' menu select=1

# 単語の一部として扱われる文字のセットを指定する
# ここではデフォルトのセットから / を抜いたものとする
# こうすると、 Ctrl-W でカーソル前の1単語を削除したとき、 / までで削除が止まる
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

export HISTFILE=~/.zsh_history   # ヒストリを保存するファイル
export HISTSIZE=1000             # メモリに保存されるヒストリの件数
export SAVEHIST=10000            # 保存されるヒストリの件数
setopt bang_hist          # !を使ったヒストリ展開を行う(d)
setopt extended_history   # ヒストリに実行時間も保存する
setopt hist_ignore_dups   # 直前と同じコマンドはヒストリに追加しない
setopt share_history      # 他のシェルのヒストリをリアルタイムで共有する
setopt hist_reduce_blanks # 余分なスペースを削除してヒストリに保存する

# ヒストリに追加されるコマンド行が古いものと同じなら古いものを削除
setopt hist_ignore_all_dups
# ヒストリを呼び出してから実行する間に一旦編集可能
setopt hist_verify
# 余分な空白は詰めて記録
setopt hist_reduce_blanks  
# 古いコマンドと同じものは無視 
setopt hist_save_no_dups
# historyコマンドは履歴に登録しない
setopt hist_no_store
