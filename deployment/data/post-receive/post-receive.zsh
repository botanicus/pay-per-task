#!/bin/zsh

# POST-RECEIVE HOOK
# ARGV: empty
# STDIN: [OLD HEAD] [NEW HEAD] refs/heads/alpha

RUBY_VERSION=2.1


unset GIT_DIR

export FN_DIR="$PWD/hooks/functions"

. $FN_DIR/functions.zsh

. $FN_DIR/environment.zsh

. $FN_DIR/limit-branch.zsh

echo

info "Reading /etc/environment and setting Ruby version."
. /etc/environment

. /usr/local/share/chruby/chruby.sh
chruby $RUBY_VERSION
ruby -v


# The target might not exist yet.
cd $(dirname $TARGET)

. $FN_DIR/print-environment.zsh

info "Deploying the top-level repository."

if [ -d $TARGET ] ; then
  cd $TARGET
  info "Updating $PWD $(trim $old) -> $(trim $new)"

  git fetch
  git reset $new --hard

  load_or_run hooks/update

  echo
  info "Tagging this deployment."
  ./bin/tag-deployment.sh

  echo
  info "Changes in this deployment:"
  echo
  git log --color $old..$new

  echo
else
  info "Cloning into $TARGET (HEAD: $(trim $new))."
  git clone $SOURCE

  cd $TARGET
  load_or_run hooks/clone

  echo
  info "Deployment is done."
  echo
fi
