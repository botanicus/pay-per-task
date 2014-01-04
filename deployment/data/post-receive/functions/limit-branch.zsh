# Only deployment branch.
if [ $BRANCH != 'deployment' ]; then
  echo
  info "Well done! To the stars and beyond!"
  info "For freedom & financial independence!"
  echo
  info "If you want to deploy, run git deploy"
  echo
  exit
fi
