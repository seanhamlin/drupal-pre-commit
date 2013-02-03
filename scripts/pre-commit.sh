#!/bin/sh
#
# This hook prevents you from committing any file containing debug
# code. e.g. dsm(), dpm(), and console.log().
#
# To enable this hook, symlink it (run this from the root of the
# repository.
#
# ln -s ../../scripts/pre-commit.sh .git/hooks/pre-commit
#
# ~/.bash_aliases
# alias gc='git commit'
# alias gcv='git commit --no-verify'
 
DIFF_FILES=`git diff-index HEAD --cached --name-only`
 
if [ $? -ne 0 ]
then
  echo "Error getting list of changed files in pre-commit hook"
  exit 4
fi
 
for FILE in ${DIFF_FILES}
do
  grep -rin -C2 "dsm" "$FILE"
 
  if [ $? -ne 0 ]
  then
    false
  else
    echo "---------------------------------------"
    echo "Found debug code - dsm() in file: $FILE"
    exit 4
  fi
done

for FILE in ${DIFF_FILES}
do
  grep -rin -C2 "dpm" "$FILE"
 
  if [ $? -ne 0 ]
  then
    false
  else
    echo "---------------------------------------"
    echo "Found debug code - dpm() in file: $FILE"
    exit 4
  fi
done

for FILE in ${DIFF_FILES}
do
  grep -rin -C2 "console\.log" "$FILE"
 
  if [ $? -ne 0 ]
  then
    false
  else
    echo "---------------------------------------"
    echo "Found debug code - console.log() in file: $FILE"
    exit 4
  fi
done

for FILE in ${DIFF_FILES}
do
  grep -rin -C2 "alert(" "$FILE"
 
  if [ $? -ne 0 ]
  then
    false
  else
    echo "---------------------------------------"
    echo "Found debug code - alert() in file: $FILE"
    exit 4
  fi
done
 
exit 0
