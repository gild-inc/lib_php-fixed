#!bin/bash

# php5.4以上のエイリアス読み込み。
PATH=$PATH:/usr/local/bin

if ! type php > /dev/null 2>&1; then
  echo $'\e[1;41mphp-fixedはphp5.4以上が必要です。README.mdを参照下さい。\e[0m'
  exit 1
fi

if [ ! -e /usr/local/bin/php ]; then
  echo $'\e[1;41mphp-fixedはphp5.4以上のエイリアスを/usr/local/binに作らなければなりません。README.mdを参照下さい。\e[0m'
  exit 1
fi

# コーディングチェックエラーがあれば {commit or push} はしない。
RESULT=$(php ./vendor/bin/phpcs --standard=phpcs.xml .)
if [ -n "$RESULT" ]; then

  # 自動修正して確認を促す。
  echo $'\e[1;47mINFO : コーディング規約に準拠していないソースコードがあります。\e[0m'

  # エラーがある。
  if [[ $RESULT =~ 'FOUND 1 ERROR' ]]; then
    echo $'\e[1;41mERROR-INFO : 自動修正を行いますが、修正点を確認してからcommitしてください。\e[0m'
    php ./vendor/bin/phpcbf --standard=phpcs.xml .
    echo $'\e[1;41mERROR=INFO : コーディング規約に準拠していないソースコードを修正しました。\e[0m'
    git diff
    exit 1
  fi

  # エラーはないが警告はある。
  if [[ ! $RESULT =~ 'FOUND 1 ERROR' ]] && [[ $RESULT =~ 'FOUND 0 ERRORS' ]]; then
    echo $'\e[1;43mWARNING-INFO : 自動修正できない箇所があります。\e[0m'
    php ./vendor/bin/phpcs --standard=phpcs.xml --report=code .
    exit 1
  fi

  # エラーも警告もなくここに到達することは通常ない。
  echo $'\e[1;41msquizlabs/php_codesnifferの仕様が変わっている可能性があります。\e[0m'

  exit 1
fi
echo $'\e[7;32mSuccess : コーディング規約に準拠していないソースコードはありません。'
exit 0
