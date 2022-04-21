#!bin/bash

# コーディングチェックエラーがあれば {commit or push} はしない。
RESULT=$(php ./vendor/bin/phpcs --standard=./phpcs-rule.xml .)
if [ -n "$RESULT" ]; then
    # 自動修正して確認を促す。
    echo $'\e[1;35mWARNING\e[0mコーディング規約に準拠していないソースコードがあります。'
    echo $'\e[1;37m自動修正を行いますが、修正点を確認してからcommitしてください。\e[0m'
    FIX=$(php ./vendor/bin/phpcbf --standard=./phpcs-rule.xml .)
    git diff
    echo $'\e[37mコーディング規約に準拠していないソースコードを修正しました。\e[0m'
    exit 1
fi

echo $'\e[7;32mSuccess\e[0mコーディング規約に準拠していないソースコードはありません。'
exit 0
