## 使用方法

本ライブラリを使用する側のリポジトリの`composer.json`に以下を追記します。

* composer.json
```json
{
    "repositories":[{
        "type": "vcs",
        "url": "git@github.gild-inc:gild-inc/library-repository-required.git"
    }],
    "require-dev": {
        "gild-inc/library-repository-required": "*"
    },
    "scripts": {
            "post-autoload-dump": [
                ". vendor/gild-inc/library-repository-required/library/laravel/setup.sh"
            ]
        }
}
```

> 本ライブラリを使用する側のリポジトリで`composer install` or `composer update` するだけです。

> 各端末の対象リポジトリのgitに対してhook制御を自動導入するようにしています。

> 本ライブラリを使用する側のリポジトリでpushするときに、masterブランチにプッシュしようとしているときそのpushはキャンセルされます。

> masterブランチ以外のpushをしたとき、PRS2に基づいたコーディングチェックを行い、コーディングエラーがあれば自動補正してそのpushはキャンセルされます。

> コーディングチェックが完全に通らないとpushは一切できません。

> 料金が馬鹿高いCIを使う必要がなくなりました。
