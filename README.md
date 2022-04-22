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

[Customisable Sniff Properties](https://github.com/squizlabs/PHP_CodeSniffer/wiki/Customisable-Sniff-Properties)

## チェックログ

以下のようなオプションでログを吐き出してはなりません。

```xml
<arg name ="report-full" value="./phpcs.log"/>
```

ログを吐き出すようにすると警告を捉えることができません。  
phpcsの出力形式が変わる設定は行わないように注意してください。

ログに出力したり出力形式を変える操作を行いたい場合は、commitまたはpushとは別に直接 `./vendor/bin/phpcs`を実行したり、composerのscriptsに独自定義します。


## gitクライアントソフトを介した挙動

※ CULでgitコマンドを直接打って操作する方は必要のない手順です。

チェックスクリプトはphpコマンドを介して実行されます。  
sourceTreeを例に挙げると読み込むシステムディレクトリは以下７つです。

* /Applications/Sourcetree.app/Contents/Resources/git_local/libexec/git-core:/Applications/Sourcetree.app/Contents/Resources/bin
* /Applications/Sourcetree.app/Contents/Resources/git_local/bin:/Applications/Sourcetree.app/Contents/Resources/git_local/gitflow
* /Applications/Sourcetree.app/Contents/Resources/git_local/git-lfs
* /usr/bin
* /bin
* /usr/sbin
* /sbin

通常、これらにphpは存在しません。  
brewによるphpのインストールであれば`/usr/local/Cellar/php@7.3/7.3.30/bin/php`や`/usr/local/opt/php@7.3`にマッピングされるのでsourceTreeが読み込むシステムディレクトリに含まれていません。
つまり、phpのコマンドに対して`command not found`が表示されチェックスクリプトは処理を継続できません。

また、sourceTreeはターミナルではない為、一般的にphpのpathが設定される`bash_profile`や`zprofile`や`zshrc`などのファイルをデフォルトでは読み込みません。  
仮に、シェルログイン時に読み込まれるこれらのファイルはユーザーに依存する部分も存在することもありターミナルエラーを引き起こす可能性がある為、チェックスクリプトでは読み込みは行っていません。  

殆どのアプリはユーザーが自作スクリプト等を疎結合に連携できるように`/usr/local/bin`を読み込むようになっていますがsourceTreeはそうなっていません。

その為、 **チェックスクリプトの処理開始冒頭で`/usr/local/bin`を読み込むようにしています。**  
つまり、`/usr/local/bin`に`php5.4以上`のエイリアスを設定するとチェックスクリプトは処理を継続することが可能になります。

ローカルに導入したphpのエイリアスを`/usr/local/bin`に作ります。

```shell
brew install php@7.3
```

```shell
export PATH="/usr/local/opt/php@7.3/bin:$PATH"
export PATH="/usr/local/opt/php@7.3/sbin:$PATH"
```

```shell
ln -s /usr/local/opt/php@7.3/bin/php /usr/local/bin/php
```

既にphp5.4以上をローカルに導入してる場合はphpが格納されている場所を調べ、そちらのエイリアスを作成します。

```shell
type php
# php is /usr/local/opt/php@7.3/bin/php
ln -s /usr/local/opt/php@7.3/bin/php /usr/local/bin/php
```

gitクライアントソフトを利用する方は上記設定をしていないとコーディングチェックの自動化は行えません。
