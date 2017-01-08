#!/bin/sh

cd _site

git init
git remote add origin https://github.com/rp/rp.github.io.git
git add .
git commit -m "deploy"
git push --set-upstream origin master --force
rm -rf .git
