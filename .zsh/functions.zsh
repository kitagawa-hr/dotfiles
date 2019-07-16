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

mkpy(){
  local dir=$1
  mkdir $dir && touch $dir/__init__.py
}
