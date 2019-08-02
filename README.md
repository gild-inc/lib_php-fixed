## 設定方法

本リポジトリを使用する側のリポジトリの`composer.json`に以下を追記します。

* composer.json
```json
{
    "repositories":[{
        "type": "vcs",
        "url": "git@github.gild-inc:gild-inc/shell-scripts.git"
    }],
    "require-dev": {
        "gild-inc/shell-scripts": "*"
    }
}
```

`composer.json`は以下の３つのファイルがある階層と同じ場所に設置しなければなりません。
* docker-compose.yml
* docker-sync.yml
* docker-sync.sh

---

本リポジトリはprivateなので`git@github.gild-inc:gild-inc/shell-scripts.git`の`github.gild-inc`に対して秘密鍵を設定する必要があります。

* ~/.ssh.config
```
# --- Sourcetree Generated ---
Host github.gild-inc
    HostName github.com
    User GILD-MasayaGoto
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/GILD-MasayaGoto-GitHub
    UseKeychain yes
    AddKeysToAgent yes
# ----------------------------
```

hostを以下のように独自にしている人は上記のように`github.gild-inc`へ修正します。

* ~/.ssh.config
```
# --- Sourcetree Generated ---
Host github.com
    HostName github.com
    User GILD-MasayaGoto
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/GILD-MasayaGoto-GitHub
    UseKeychain yes
    AddKeysToAgent yes
# ----------------------------

とか

# --- Sourcetree Generated ---
Host GILD-MasayaGoto-GitHub
    HostName github.com
    User GILD-MasayaGoto
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/GILD-MasayaGoto-GitHub
    UseKeychain yes
    AddKeysToAgent yes
# ----------------------------
```

## プロジェクトセットアップ

dockerリポジトリ `xxx-docker/config/.env.vendor` に最低限以下の２つのkeyの設定をします。

* PROJECT_NAME
* HOST

```env
PROJECT_NAME=master-aggregation
HOST=local.master-aggregation.jp
```

> `xxx-docker/first-set-up.sh`を実行すると、composer本体の更新と依存関係の更新が始まります。  

> 次に、本リポジトリの`projects-build/first-set-up.sh`が実行されます。  

> `projects-build/first-set-up.sh`は`xxx-docker/config/.env.vendor`を読み込みます。

> `xxx-docker`の`xxx`の部分を原点として、`docker`と`projects`で分岐し、更に`projects`は`api`と`view`に分岐されます。

>この`xxx`の部分が`PROJECT_NAME`に該当します。


<div align="center">
<img width="75%" src="https://user-images.githubusercontent.com/38495787/62300655-246fdd00-b4b2-11e9-851c-b22ae15c15fb.png">
</div>

ディレクトリ構成とリポジトリ名に一貫性がある為、git cloneするリポジトリ名やclone先の場所などをプログラム側で捉えられるように工夫しています。

弊社では、SPA開発がメインの為、例外を除き上記ディレクトリ構成がぶれることはないでしょう。


`HOST` はSSL証明書を作成する際の-dオプションに利用しています。


## コンテナの起動・停止・ダウン

docker-syncをinstallしていない場合は、installを行ってくれます。

docker-sync.shに対して引数でコマンドを渡します。  
コマンドがない場合は以下の表記でサポートします。

```
'. docker-sync.sh up'   ->  docker-syncでコンテナの起動を行います。
'. docker-sync.sh stop' ->  コンテナの停止を行います。
'. docker-sync.sh down' ->  コンテナ及びVolumesのプロセスを終了します。
```

`docker-sync.sh up`は`projects-build/first-set-up.sh`内でも実行しています。