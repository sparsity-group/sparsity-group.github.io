#!/bin/sh

cd _site
git init
git add .
git commit -m "deploy"
git remote add origin https://github.com/rp/rp.github.io.git
git push --set-upstream origin master --force
