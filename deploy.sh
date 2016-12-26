#!/bin/bash

cd _site

# Super hacky and terrible practice. DO NOT DO THIS
git clone https://github.com/rp/rp.github.io.git old
mv old/.git .

echo -n "Commit Message: " ; read -e msg

rm -rf old
git add .
git commit -m "Deploy: $msg"

git push
rm -rf .git
