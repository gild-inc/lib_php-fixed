#!bin/bash

# コーディングチェックエラーがあればpushはしない。

RESULT=$(php ./vendor/bin/phpcs --standard=./php-fixed-rule.xml .)
if [ -n "$RESULT" ]; then
    # コーディングエラーがあれば自動修正して確認を促す。
    echo $'\e[1;35mWARNING\e[0mコーディングエラーがあります。'
    echo $'\e[1;37m自動修正し、pushは行いません。\e[0m'
    FIX=$(php ./vendor/bin/phpcbf --standard=./php-fixed-rule.xml .)
    git diff
    echo $'\e[37mコーディング規約に準拠していないソースコードを修正しました。\e[0m'
    echo $'\e[37m差分を確認して問題がなければ、コミット、再プッシュしてください。\e[0m'
    exit 1
fi

echo $'\e[7;32mSuccess\e[0mコーディングエラーはありません。'
exit 0
