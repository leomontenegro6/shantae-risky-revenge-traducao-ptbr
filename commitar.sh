#!/bin/bash
read -p "Digite o texto do commit: `echo $'\n> '`" COMMIT

git config --global user.name "leomontenegro6"
git config --global user.email "leomontenegro6@gmail.com"

git add --all
git commit -am "$COMMIT"
git push
