## 概要
PSRに準拠したphpのコーディングチェックをコミット前に行うことでコミットログを綺麗に保つ機構を提供するライブラリです。

## 導入方法

リポジトリルートの`composer.json`に以下を追記します。
`execution.sh`の引数には `commit` か `push` を指定します。

* composer.json
```json
{
    "require-dev": {
        "gild/php-fixed": "^2.0"
    },
    "scripts": {
        "post-autoload-dump": [
            "bash vendor/gild/php-fixed/execution.sh commit"
        ],
        "check": [
            "bash vendor/gild/php-fixed/src/php-codesniffer/code_check.sh"
        ],
        "lint": [ 
            "php ./vendor/bin/phpcs --standard=./phpcs-rule.xml ."
        ],
        "lint-fix": [
            "php ./vendor/bin/phpcbf --standard=./phpcs-rule.xml ."
        ]
    }
}
```

```
'. execution.sh commit'   ->  コミット前にコーディングチェックを行います。
'. execution.sh push'     ->  プッシュ前にコーディングチェックを行います。コミット前のチェックは行いません。
```

## ルール設定方法
`phpcs-rule.xml`は管理対象ファイルとしてください。
独自にルールを書き換えて自由に設定可能です。

## チェックログ
一番初めにチェックスクリプトを走らせると`phpcs.log`がルートディレクトリに作成されます。
チェックスクリプトを実行する度に、ログファイルを削除して再度新しくログファイルを作成しています。
従って、前回実行時のログは残りません。
このログファイルは基本的に`.gitignore`へ追加します。
