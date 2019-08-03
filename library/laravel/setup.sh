#!bin/bash

cp vendor/gild-inc/library-repository-required/library/laravel/git/hooks/pre-push .git/hooks/
mkdir -p .github
cp vendor/gild-inc/library-repository-required/.github/* .github
