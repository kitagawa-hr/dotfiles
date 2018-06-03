

# zplug
source ~/.zplug/init.zsh
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
# theme (https://github.com/sindresorhus/pure#zplug
zplug "mafredri/zsh-async"
zplug "sindresorhus/pure"
# 構文のハイライト(https://github.com/zsh-users/zsh-syntax-highlighting)
zplug "zsh-users/zsh-syntax-highlighting"
# history関係
zplug "zsh-users/zsh-history-substring-search"
# タイプ補完
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "chrissicool/zsh-256color"
# 簡単にgitrootへcd
zplug "mollifier/cd-gitroot"
# 移動強化

# 補完強化
zplug "zsh-users/zsh-completions"
# インタラクティブフィルタ
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "junegunn/fzf", as:command, use:bin/fzf-tmux
#peco
zplug "peco/peco", as:command, from:gh-r, use:"*amd64*"
# gomi でゴミ箱に 
zplug "b4b4r07/zsh-gomi", as:command, use:bin

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi
# Then, source plugins and add commands to $PATH
zplug load

# 色を使用出来るようにする
autoload -Uz colors
colors

bindkey -v

#プロンプト
PROMPT="%{$fg[green]%}%n%(!.#.$) %{$reset_color%}"
PROMPT2="%{$fg[green]%}%_> %{$reset_color%}"
SPROMPT="%{$fg[red]%}correct: %R -> %r [nyae]? %{$reset_color%}"
RPROMPT="%{$fg[cyan]%}[%~]%{$reset_color%}"

# 環境変数
export LANG=ja_JP.UTF-8


#エイリアス
alias jb='jupyter notebook'
alias sp3='spyder3'
alias vim='nvim'
alias la='ls -a'

# 2つ上、3つ上にも移動できるようにする
alias ...='cd ../..'
alias ....='cd ../../..'

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

#自動補間
autoload -U compinit; compinit

# 入力したコマンドが存在せず、かつディレクトリ名と一致するなら、ディレクトリに cd する
setopt auto_cd
#移動強化
#~/.peco/z-pathsにpathを追加
#z add でディレクトリを追加 z editで一覧
#https://qiita.com/junkoda/items/69b9360ca0f843342eb1
function _z {
  compadd `cat $HOME/.peco/z-paths | sed 's|.*/||'`
}

compdef _z z

# z <dir>
# z add . : add current directory to directory list
# z edit  : edit the directory list with $ZEDIT

function z() {
  local PCD_FILE=$HOME/.peco/z-paths
  local PCD_RETURN
  local ZEDIT=${EDITOR:-emacs} # set your favourite editor

  if [ $1 ] && [ $1 = "add" ]; then
    # z add <dir>
    if [ $2 ]; then
      local ADD_DIR=$2
      if [ $2 = "." ]; then
        ADD_DIR=$(pwd) 
      fi
      echo "Adding $ADD_DIR to $PCD_FILE"
      echo $ADD_DIR >> $PCD_FILE
    fi
  elif [ $1 ] && [ $1 = "edit" ]; then
    # z edit
    $ZEDIT $PCD_FILE
  elif [ $1 ] && [ $1 = "." ]; then
    PCD_RETURN=$(/bin/ls -F | grep /$ | sort | peco)
  elif [ $1 ]; then
    # z <dir> unique matching
    local GREP_RETURN
    local grepcmd="cat $PCD_FILE"
    for pat in $*
    do
      grepcmd="$grepcmd | grep -e '/$pat'"
    done

    grepcmd=`echo $grepcmd | sed "s/'$/\$'/"`

    GREP_RETURN=`eval $grepcmd`
    echo "grep return = $GREP_RETURN"

    if [ `expr "$GREP_RETURN" : '.*'` -ne 0 -a \
     $(echo $GREP_RETURN | wc -l) -eq 1 ]; then
      # unique match
      PCD_RETURN=$GREP_RETURN
    else
      PCD_RETURN=$(cat $PCD_FILE | sort | peco --query "$*")
    fi
  else
    PCD_RETURN=$(cat $PCD_FILE | sort | peco)
  fi

  if [ $PCD_RETURN ]; then
    echo $PCD_RETURN
    cd $PCD_RETURN
  fi
}

# "~hoge" が特定のパス名に展開されるようにする（ブックマークのようなもの）
# 例： cd ~hoge と入力すると /long/path/to/hogehoge ディレクトリに移動
hash -d hoge=/long/path/to/hogehoge

# cd した先のディレクトリをディレクトリスタックに追加する
# ディレクトリスタックとは今までに行ったディレクトリの履歴のこと
# `cd +<Tab>` でディレクトリの履歴が表示され、そこに移動できる
setopt auto_pushd

# pushd したとき、ディレクトリがすでにスタックに含まれていればスタックに追加しない
setopt pushd_ignore_dups

# 拡張 glob を有効にする
# glob とはパス名にマッチするワイルドカードパターンのこと
# （たとえば `mv hoge.* ~/dir` における "*"）
# 拡張 glob を有効にすると # ~ ^ もパターンとして扱われる
# どういう意味を持つかは `man zshexpn` の FILENAME GENERATION を参照
setopt extended_glob

### History ###
# 入力したコマンドがすでにコマンド履歴に含まれる場合、履歴から古いほうのコマンドを削除する
# コマンド履歴とは今まで入力したコマンドの一覧のことで、上下キーでたどれる
setopt hist_ignore_all_dups

# コマンドがスペースで始まる場合、コマンド履歴に追加しない
# 例： <Space>echo hello と入力
setopt hist_ignore_space

# <Tab> でパス名の補完候補を表示したあと、
# 続けて <Tab> を押すと候補からパス名を選択できるようになる
# 候補を選ぶには <Tab> か Ctrl-N,B,F,P
zstyle ':completion:*:default' menu select=1

# 単語の一部として扱われる文字のセットを指定する
# ここではデフォルトのセットから / を抜いたものとする
# こうすると、 Ctrl-W でカーソル前の1単語を削除したとき、 / までで削除が止まる
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
## Set path for pyenv
export PYENV_ROOT="${HOME}/.pyenv"
if [ -d "${PYENV_ROOT}" ]; then
    export PATH=${PYENV_ROOT}/bin:$PATH
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

function peco-history-selection() {
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection
bindkey "^[OH" beginning-of-line
bindkey "^[OF" end-of-line
bindkey "^[[3~" delete-char

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
#spark                                                                                                                                                        
export SPARK_HOME=/usr/local/spark/spark-1.6.2-bin-hadoop2.6
export PATH=$PATH:$SPARK_HOME/bin
#jupyter spark
export PYSPARK_PYTHON=$PYENV_ROOT/shims/python #環境に合わせてパスを合わせること
export PYSPARK_DRIVER_PYTHON=$PYENV_ROOT/shims/jupyter
export PYSPARK_DRIVER_PYTHON_OPTS="notebook"
export XDG_CONFIG_HOME="$HOME/.config"



[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
