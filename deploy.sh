#!/bin/bash

cd _site

# Super hacky and terrible practice. DO NOT DO THIS
if [ -a old ] ; then
    git clone https://github.com/rp/rp.github.io.git old
    mv old/.git .
    rm -rf old

    echo -n "Commit Message: " ; read -e msg

    git add .
    git commit -m "Deploy: $msg"
fi

git push
