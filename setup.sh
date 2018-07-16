#!/bin/bash
set -euxo pipefail

PATH=/home/vagrant/.gem/ruby/2.4.0/bin:$PATH
type rails >/dev/null 2>&1 || gem install rails --pre --user
echo 'PATH=/home/vagrant/.gem/ruby/2.4.0/bin:$PATH' >> ~/.bashrc
rails -v

# workaround
type spring >/dev/null 2>&1 || gem install spring --user

if [ ! -d memo-app-r ]; then
    rails new memo-app-r --database=postgresql
    cd memo-app-r
    git add .
    git commit -m "Initial commit"
    rails db:create
fi
