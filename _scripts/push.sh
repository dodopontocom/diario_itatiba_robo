#!/bin/sh

STD_MSG="lib carregada..."

setup_git() {
  git config --global user.email "$1"
  git config --global user.name "$2"
}

commit_website_files() {
  git checkout -b gh-pages
  git add . *.html
  git commit --message "Travis build: $TRAVIS_BUILD_NUMBER"
}

upload_files() {
  git remote add origin-pages https://${GH_TOKEN}@github.com/dodopontocom/diario_itatiba_robo.git > /dev/null 2>&1
  git push --quiet --set-upstream origin-pages docker-v1.0
}
