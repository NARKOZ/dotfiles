#!/bin/sh
# Usage: git-cv <upstream> [<head> [<limit>]]
# Humane git-cherry view. Show commits not merged upstream
# like git-cherry with verbose output, short SHAs, and ANSI
# color.

for a in "$@" ; do
    test "$a" = "--help" &&
    exec git cherry --help
done

SHA=$(git config --get-color 'color.branch.local')
ADD=$(git config --get-color 'color.diff.new')
REM=$(git config --get-color 'color.diff.old')
RESET=$(git config --get-color '' 'reset')

git cherry -v "$@"                                |
cut -c1-9 -c43-                                   |
sed -e "s/^\(.\) \(.......\)/\1 $SHA\2$RESET/"    |
sed -e "s/^-/$REM-$RESET/" -e "s/^+/$ADD+$RESET/"
