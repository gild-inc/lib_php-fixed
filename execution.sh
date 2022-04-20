#!bin/bash

if [ $# -eq 0 ]; then
    echo "引数は必須です。"
    echo "'. execution.sh commit'   ->  コミット前にコーディングチェックを行います。"
    echo "'. execution.sh push'     ->  プッシュ前にコーディングチェックを行います。コミット前のチェックは行いません。"
    return
fi

mkdir -p .git/hooks/
cp vendor/gild/php-fixed/src/repository/git/hooks/pre-$1 .git/hooks/
