#!/bin/sh

# grabs most recent cv from GitHub
make_cv() {
    mkdir -p files

    WORKING_DIR=$(pwd)
    CV_DIR=$(mktemp -d)

    git clone https://github.com/rp/rahul-cv.git $CV_DIR
    cd $CV_DIR

    make

    mv *.pdf "$WORKING_DIR/files"

    cd $WORKING_DIR
    rm -rf $CV_DIR
}

# pushes site to GitHub
push() {
    git init
    git remote add origin https://github.com/rp/rp.github.io.git
    git add .
    git commit --allow-empty-message -m ""
    git push --set-upstream origin master --force
    rm -rf .git
}

deploy() {
    cd _site
    make_cv
    push
}

if [ -d "$DIRECTORY" ]; then
    deploy
else
    stack exec site build
    deploy
fi
