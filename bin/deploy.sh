#! /bin/sh
#
# deploy.sh
#
# Deploy dotfiles to home directory.
# 
# Copyright (C) 2018 yukihira1992 <hirayama@cancerscan.jp>
#
# Distributed under terms of the MIT license.
#

cd `dirname $0`"/.."

for file in .??*
do
    [[ "$file" == ".DS_Store" ]] && continue
    [[ "$file" == ".git" ]] && continue
    [[ "$file" == ".gitmodule" ]] && continue
    ln -s $PWD"/"$file $HOME
done

