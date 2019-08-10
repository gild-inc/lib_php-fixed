## 概要
特定のgit操作によってトリガーされるスクリプトを提供するライブラリです。
push時にmasterに

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
                "cp vendor/gild-inc/git-hooks/any/git/hooks/pre-push .git/hooks/"
            ]
        }
}
```

* リポジトリルートでpushするときに、masterブランチにプッシュしようとしているときそのpushはキャンセルされます。

* プロジェクトによっては、PRS2に基づいたコーディングチェックを行い、コーディングエラーがあれば自動補正してそのpushはキャンセルされます。

* コーディングチェックが完全に通らないとpushは一切できません。

> 料金が馬鹿高いCIを使う必要がなくなりました。
