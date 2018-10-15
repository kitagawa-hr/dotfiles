#!/usr/local/bin/zsh


# tex hoge.tex -> hoge.pdf
tex(){
  local file=$1
  docker run --rm -v $PWD:/workdir paperist/alpine-texlive-ja uplatex $file && \
  docker run --rm -v $PWD:/workdir paperist/alpine-texlive-ja dvipdfmx ${file/tex/dvi}
}
