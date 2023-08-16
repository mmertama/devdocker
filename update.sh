#!/bin/bash

set -e

TARGET=$1

if [[ -z "$TARGET" ]]; then
    echo "A target folder needed"
    exit 1
fi


if [[ -d "$TARGET/.git" ]]; then
    echo "Please do not target to a repository folder"
    exit 1
fi

# clean off as assumption is to get new ones...
rm -rf cli
rm -rf gui

# optional create
mkdir -p "$TARGET"

pushd  "$TARGET" > /dev/null

wget -q https://github.com/mmertama/devdocker/archive/refs/heads/master.zip \
&& unzip -qo master.zip \
&& rm master.zip \
&& mv -f devdocker-main/* . \
&& rm -rf devdocker-main


popd > /dev/null
