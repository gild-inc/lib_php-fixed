#!bin/bash

cp vendor/gild-inc/library-repository-required/library/any/git/hooks/pre-push .git/hooks/
mkdir -p .github
cp vendor/gild-inc/library-repository-required/.github/* .github
