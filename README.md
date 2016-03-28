# Drupal pre-commit hook #

For more information [see the blog post on pixelite](http://www.pixelite.co.nz/article/using-git-pre-commit-hooks-keep-you-drupal-codebase-clean). If this script has helped you or you want to leave a comment, you can do so on the blog.

## Installation instructions

This is covered in the actual script as well, but for the sake of making it easy to find:

```
cd [PATH TO DRUPAL GIT REPO]
mkdir scripts
curl -sL https://raw.githubusercontent.com/wiifm69/drupal-pre-commit/master/scripts/pre-commit.sh > ./scripts/pre-commit.sh
ln -s ../../scripts/pre-commit.sh .git/hooks/pre-commit
```

On a side note, I normally encourage your Drupal docroot to be in a sub folder called <code>docroot</code>, this way the scripts directory will not be served via your web server.

## Possible enhancements ##

* JavaScript linting
* Drupal Code Standards (phpcs + coder) integration
* Having some configuration options (perhaps environment variables?) as to what will cause a the commit to fail, versus a warning

I am also wanting people to submit pull requests as well.
