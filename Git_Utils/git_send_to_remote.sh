#!/bin/bash

git add *.pas
git add *.lpi
git add *.lpr
git add *.res
git add *.lps
git add *.lfm
git add *.pp
git add *.inc
git add *.txt
git add *.ini
git add *.sh
git add *.bat
git commit -m $@
git push -u origin master
