#!/bin/bash
curl -u Turro75 https://api.github.com/user/repos -d "{\"name\":\"${1}\"}"
git init
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
git commit -m "First Commit"
git remote add origin "https://github.com/Turro75/${1}.git"
git push -u origin master
