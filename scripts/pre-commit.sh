#!/bin/sh
#
# This hook prevents you from committing any file containing debug code.
# e.g. dsm(), dpm(), alert() and console.log(). There is also a PHP LINT check
# to ensure your syntax is okay.
#
# To enable this hook, symlink it (run this from the root of the repository).
#
# ln -s ../../scripts/pre-commit.sh .git/hooks/pre-commit
#
# To force a commit that breaks the below rules (e.g. when debug code is 100%
# required you can add in another parameter to `git commit` namely `--no-verify`.
#
# Helpful git aliases for these are:
# git config --global alias.gc commit
# git config --global alias.gcv commit --no-verify
 
DIFF_FILES=`git diff-index HEAD --cached --name-only`
 
if [ $? -ne 0 ]
then
  echo "Error getting list of changed files in pre-commit hook"
  exit 4
fi
 
# dsm() statement shoud not be committed, these run against PHP code only.
for FILE in ${DIFF_FILES}
do
  PARSEABLE=$(echo "$FILE" | grep -E "\.(php|module|install|inc)$");
  if [ "$PARSEABLE" != "" ]; then
    grep -rin -C2 "dsm" "$FILE"
    if [ $? -ne 0 ]
    then
      false
    else
      echo "---------------------------------------"
      echo "Found debug code - dsm() in file: $FILE"
      exit 4
    fi
  fi
done

# dpm() statement shoud not be committed, these run against PHP code only.
for FILE in ${DIFF_FILES}
do
  PARSEABLE=$(echo "$FILE" | grep -E "\.(php|module|install|inc)$");
  if [ "$PARSEABLE" != "" ]; then
    grep -rin -C2 "dpm" "$FILE"
    if [ $? -ne 0 ]
    then
      false
    else
      echo "---------------------------------------"
      echo "Found debug code - dpm() in file: $FILE"
      exit 4
    fi
  fi
done

# console.log() statement shoud not be committed, these run against JS code only.
for FILE in ${DIFF_FILES}
do
  PARSEABLE=$(echo "$FILE" | grep -E "\.(js|coffee)$");
  if [ "$PARSEABLE" != "" ]; then
    grep -rin -C2 "console\.log" "$FILE"
    if [ $? -ne 0 ]
    then
      false
    else
      echo "---------------------------------------"
      echo "Found debug code - console.log() in file: $FILE"
      exit 4
    fi
  fi
done

# alert() statement shoud not be committed, these run against JS code only.
for FILE in ${DIFF_FILES}
do
  PARSEABLE=$(echo "$FILE" | grep -E "\.(js|coffee)$");
  if [ "$PARSEABLE" != "" ]; then
    grep -rin -C2 "alert" "$FILE"
    if [ $? -ne 0 ]
    then
      false
    else
      echo "---------------------------------------"
      echo "Found debug code - alert() in file: $FILE"
      exit 4
    fi
  fi
done

# PHP LINT syntax checks, these run against PHP code only.
for FILE in ${DIFF_FILES}
do
  PARSEABLE=$(echo "$FILE" | grep -E "\.(php|module|install|inc)$");
  if [ "$PARSEABLE" != "" ]; then
    php -l $FILE > /dev/null 2>&1
    ERRORS=$?
    if [ $ERRORS -eq 255 ]; then
      ERROR_FILES="$ERROR_FILES $FILE"
    fi
  fi
done
if [ "$ERROR_FILES" != "" ]; then
  echo "---------------------------------------"
  echo "These errors were found in try-to-commit files: "
  for ERROR_FILE in ${ERROR_FILES}
  do
    php -l $ERROR_FILE 2>&1 | grep "Parse error"
  done
  echo "---------------------------------------"
  echo "Can't commit, fix errors first."
  exit 4
fi
 
exit 0
