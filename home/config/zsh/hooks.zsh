function git_repo_chpwd() {
  test -x .git/chpwd && ./git/chpwd
}

typeset -a chpwd_functions
chpwd_functions+=(git_repo_chpwd)
