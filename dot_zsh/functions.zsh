#!/usr/local/bin/zsh


# tex hoge.tex -> hoge.pdf
tex(){
  local file=$1
  docker run --rm -v $PWD:/workdir paperist/alpine-texlive-ja uplatex $file && \
  docker run --rm -v $PWD:/workdir paperist/alpine-texlive-ja dvipdfmx ${file/tex/dvi}
}


runghc(){
  local file=/workdir/$1
  docker run --rm -v $PWD:/workdir haskell runghc $file
}

function fzf-ghq() {
  local selected_dir=$(ghq list | fzf --query="$LBUFFER" --prompt="Git Repos > ")
  if [ -n "$selected_dir" ]; then
    cd $(ghq root)/${selected_dir}
  fi
}
