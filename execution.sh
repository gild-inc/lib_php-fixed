#!bin/bash

if [ $# -eq 0 ]; then
    echo "引数は必須です。"
    echo "'. execution.sh any'      ->  dockerなどプロジェクトに属さないリポジトリのgit-hook設定を行います。"
    echo "'. execution.sh laravel'  ->  laravelの標準ディレクトリ構成をベースにしたPSR2チェックを行うgit-hook設定を行います。"
    return
fi

if [ -e vendor/gild-inc/git-hooks/1 ]; then
    . vendor/gild-inc/git-hooks/$1/execution.sh
else
    echo "指定した引数は有効ではありません。"
fi