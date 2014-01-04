error()   { printf "\e[1;31m$*\e[0m\n\n"; }
abort()   { error $*; exit 1; }
success() { printf "\e[1;32m$*\e[0m\n"; }
info()    { printf "\e[1;34m$*\e[0m\n"; }
debug()   { $DEBUG && printf "\e[1;33m$*\e[0m\n"; }
run()     { info $* ; $*; }

trim () {
  echo $1 | cut -c 1-5
}

load_or_run () {
  if [ -x $1 ] ; then
    info "Running ./$1"
    ./$1
  elif [ -f $1 ] ; then
    info "Loading $1"
    . $1 # so user can use functions defined in this hook in his update hook
  else
    error "Hook $1 wasn't found in $PWD!"
  fi
}
