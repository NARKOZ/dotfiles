_cheat_complete () {
  COMPREPLY=()
  if [ $COMP_CWORD = 1 ]; then
    sheets=`cheat sheets | grep '^  '`
    COMPREPLY=(`compgen -W "$sheets" -- $2`)
  fi
}
complete -F _cheat_complete cheat
