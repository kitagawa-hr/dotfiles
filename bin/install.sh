#! bin/sh

cd `dirname $0`

if [ "$(uname)" == "Darwin" ]; then
    sh ./platforms/osx/install.sh
else
    echo "Unsupported platform."
    exit 1
fi
