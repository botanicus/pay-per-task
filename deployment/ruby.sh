#!/usr/bin/env zsh

RUBY_VERSION=2.1

source /usr/local/share/chruby/chruby.sh
chruby $RUBY_VERSION || ruby-install ruby $RUBY_VERSION -- --disable-install-doc

chruby $RUBY_VERSION
gem install bundler
