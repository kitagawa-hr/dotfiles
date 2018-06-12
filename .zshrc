
# OS別設定読み込み
case ${OSTYPE} in
    darwin*)
        source ~/.zshrc.osx
        ;;
    linux*)
        source ~/.zshrc.linux
        ;;
esac

# auto zcompile
if [ ~/.zshrc -nt ~/.zshrc.zwc ]; then
   zcompile ~/.zshrc
fi

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




#エイリアス
alias jb='jupyter notebook'
alias sp3='~/.pyenv/shims/spyder3'
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
# ~ ^ もパターンとして扱われる
setopt extended_glob





[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

