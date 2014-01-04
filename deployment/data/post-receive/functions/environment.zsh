export TERM="xterm-color"

set -- $(cat /dev/stdin)

old=$1 && new=$2 && ref=$3

export DEBUG=true

export NAME=$(basename $PWD)
export BRANCH=$(basename $ref)

export SOURCE=$PWD

# This has to be here for the cd on line 24.
if [ $NAME = 'ppt' ]; then
  export TARGET="/webs/ppt"
else
  export TARGET="/webs/ppt/$NAME"
fi

cd $(dirname $TARGET)
