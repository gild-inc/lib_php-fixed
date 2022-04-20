## 概要
PSRに準拠したphpのコーディングチェックをコミット前に行うことでコミットログを綺麗に保つ機能を提供するライブラリです。

## 設定方法

リポジトリルートの`composer.json`に以下を追記します。
引数には `commit` か `push` を指定します。

* composer.json
```json
{
    "require-dev": {
        "gild/php-fixed": "*"
    },
    "scripts": {
        "post-autoload-dump": [
            ". vendor/gild/php-fixed/execution.sh commit"
        ]
    }
}
```

```
'. execution.sh commit'   ->  コミット前にコーディングチェックを行います。
'. execution.sh push'     ->  プッシュ前にコーディングチェックを行います。コミット前のチェックは行いません。
```
