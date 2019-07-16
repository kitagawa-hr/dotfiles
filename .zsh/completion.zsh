



#移動強化
#~/.peco/z-pathsにpathを追加
#z add でディレクトリを追加 z editで一覧
#https://qiita.com/junkoda/items/69b9360ca0f843342eb1
function _z {
  compadd `cat $HOME/.peco/z-paths | sed 's|.*/||'`
}
# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 補完侯補をメニューから選択する。
# select=2: 補完候補を一覧から選択する。
#           ただし、補完候補が2つ以上なければすぐに補完する。
zstyle ':completion:*:default' menu select=2

# 補完候補に色を付ける。
# "": 空文字列はデフォルト値を使うという意味。
zstyle ':completion:*:default' list-colors ""

# 補完候補がなければより曖昧に候補を探す。
# m:{a-z}={A-Z}: 小文字を大文字に変えたものでも補完する。
# r:|[._-]=*: 「.」「_」「-」の前にワイルドカード「*」があるものとして補完する。
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z} r:|[._-]=*'

# 補完方法の設定。指定した順番に実行する。
# _oldlist 前回の補完結果を再利用する。
# _complete: 補完する。
# _match: globを展開しないで候補の一覧から補完する。
# _history: ヒストリのコマンドも補完候補とする。
# _ignored: 補完候補にださないと指定したものも補完候補とする。
# _approximate: 似ている補完候補も補完候補とする。
# _prefix: カーソル以降を無視してカーソル位置までで補完する。
zstyle ':completion:*' completer \
    _oldlist _complete _match _history _ignored _approximate _prefix
# 補完候補をキャッシュする。
zstyle ':completion:*' use-cache yes
# 詳細な情報を使う。
zstyle ':completion:*' verbose yes


# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin




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



function _complete_ft() {
    local ret=1
    local subcommands=(
      "abspath"
      "add"
      "append"
      "at"
      "basename"
      "capitalize"
      "const"
      "contains"
      "dirname"
      "drop"
      "duplicate"
      "ends_with"
      "endswith"
      "eq"
      "equal"
      "equals"
      "even"
      "exists"
      "file_ext"
      "filesize"
      "format"
      "ge"
      "greater"
      "greater_equal"
      "greater_equals"
      "greater_than"
      "gt"
      "has_ext"
      "id"
      "identity"
      "index"
      "is_dir"
      "is_file"
      "is_link"
      "join"
      "le"
      "len"
      "length"
      "less"
      "less_equal"
      "less_equals"
      "less_than"
      "lt"
      "mul"
      "ne"
      "non_empty"
      "nonempty"
      "not_equal"
      "not_equals"
      "odd"
      "pow"
      "prepend"
      "replace"
      "replace_ext"
      "run"
      "split"
      "split_ext"
      "starts_with"
      "startswith"
      "strip"
      "strip_ext"
      "sub"
      "substr"
      "take"
      "to_lower"
      "to_upper"
    )
    _describe -t subcommands 'ft-functions subcommands' subcommands && ret=0
    return ret
}
compdef _complete_ft map
compdef _complete_ft filter
compdef _complete_ft foldl

