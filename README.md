## 概要
特定のgit操作によってトリガーされるスクリプトを提供するライブラリです。

## 使用方法

リポジトリルートの`composer.json`に以下を追記します。

* composer.json
```json
{
    "repositories":[
        {
            "type": "vcs",
            "url": "git@github.gild-inc:gild-inc/lib-git-hooks.git"
        }
    ],
    "require-dev": {
        "gild-lib/git-hooks": "*"
    },
    "scripts": {
        "post-autoload-dump": [
            ". vendor/gild-lib/git-hooks/execution.sh {any or laravel}"
        ]
    }
}
```

### any
* masterブランチにプッシュしようとしているときそのpushはキャンセルされます。
* コーディングチェックは行われません。

### laravel
* masterブランチにプッシュしようとしているときそのpushはキャンセルされます。
* コーディングチェックはlaravelの標準ディレクトリ構成をベースにしたPSR2チェックを実施します。
