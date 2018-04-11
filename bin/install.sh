#! /bin/sh
#
# install.sh
#
# Install minimal packages by package manager.
#
# Copyright (C) 2018 yukihira1992 <hirayama@cancerscan.jp>
#
# Distributed under terms of the MIT license.
#

cd `dirname $0`

if [ "$(uname)" == "Darwin" ]; then
    sh ./platforms/osx/install.sh
else
    echo "Unsupported platform."
    exit 1
fi
