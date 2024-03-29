## 概要
PSRに準拠したphpのコーディングチェックをコミット前に行うことでコミットログを綺麗に保つ機構を提供するライブラリです。

## 導入要件

* ローカル環境PHP > ver5.4

## 導入方法

`composer.json`に以下追加します。

```json
{
    "scripts": {
        "post-autoload-dump": [
            "bash vendor/gild/php-fixed/execution.sh commit"
        ],
        "check": [
            "bash .git_hooks/pre-commit/main.sh"
        ],
        "lint": [ 
            "phpcs --standard=phpcs.xml -sp ."
        ],
        "lint:fix": [
            "phpcbf --standard=phpcs.xml -sp ."
        ]
    }
}
```

```shell
composer require --dev gild/php-fixed ^3.0
```

check, lint, lint:fixは任意で設定するものになります。  
post-autoload-dumpが重要です。

### post-autoload-dump

`execution.sh {triggerType}`

```
'. execution.sh commit'   ->  コミット前にコーディングチェックを行います。
'. execution.sh push'     ->  プッシュ前にコーディングチェックを行います。コミット前のチェックは行いません。
```


### check

commitを行わずに、単にコーディングチェックから自動修正まで一気通貫して行いたい場合に使用します。これは`lint`と`lint:fix`の組み合わせです。

commit時に行われる、`コーディングチェックから自動修正`までの処理は`composer check`を呼び出しているわけではありません。
checkエイリアス自体の処理は本ライブラリを組み込む際の依存関係はないものとなります。
lintとlint:ixについても同様です。

### lint

commitを行わずに、単にコーディングチェックを行いたい場合に使用します。

### lint:fix

commitを行わずに、単に自動修正を行いたい場合に使用します。

## 管理対象ファイルについて

以下は管理対象ファイルとしてください。

### phpcs.xml

このファイルはリポジトリ直下に生成されます。  
Laravelをベースにルール定義していますが 、独自にルールを書き換えて自由に設定可能です。
[Customisable Sniff Properties](https://github.com/squizlabs/PHP_CodeSniffer/wiki/Customisable-Sniff-Properties)

ファイル名を変更することは可能ですが、`main.sh`でファイル名変更することを忘れないで下さい。

### main.sh
このファイルはリポジトリ直下に生成されるgit-hooks/pre-{triggerType}配下に生成されます。  
処理自体は利用者が設定管理することが可能です。 ファイル名の変更は不可です。

## gitクライアントソフトを介した挙動

※ CULでgitコマンドを直接打って操作する方は必要のない手順です。

チェックスクリプトはphpコマンドを介して実行されますが、gitクライアントソフトではphpのpathを読み込まないものもある為、 チェックスクリプトの処理開始冒頭で`/usr/local/bin`を読み込むようにしています。

従って、ローカル環境に導入したphpのエイリアスを`/usr/local/bin`に作っていただくことになります。
以下エイリアス作成例です。

```shell
ln -s /usr/local/opt/php@7.3/bin/php /usr/local/bin/php
```

---

既にphp5.4以上をローカルに導入してる場合はphpが格納されている場所を調べ、そちらのエイリアスを作成します。

```shell
type php
# php is /usr/local/opt/php@7.3/bin/php
ln -s /usr/local/opt/php@7.3/bin/php /usr/local/bin/php
```

gitクライアントソフトを利用する方は上記設定をしていないとコーディングチェックの自動化は行えません。


## 注意点

### 出力形式やログについて

以下のような出力形式が変わるオプションは`phpcs.xml`に定義してはなりません。
ログを吐き出すようにするとチェックスクリプトが警告を捉えることができません。

```xml
<arg value="sp" />
<arg name ="report-full" value="./phpcs.log" />
```

チェックスクリプトを介さなければ自由に設定しても構いませんので、その為にcomposer.jsonのscriptsに独自定義します。

```json
{
    "scripts": {
        "lint": [
          "phpcs --standard=phpcs.xml -sp ."
        ],
        "lint:fix": [
          "phpcbf --standard=phpcs.xml -sp ."
        ]
    }
}
```

### 既にgit-hookを使われてる方について

本ライブラリ導入前にgit-hookを利用しているケースで既にpre-commitやpre-pushに何かしらのスクリプトを記述している場合を想定し、削除や上書きはしておりません。

pre-commitやpre-pushは`.buckup`という接尾辞を付与して退避しています。

## 補足
可能であればローカル環境への別途導入物はライブラリに依存すべきではないと考えていますが、git操作はローカル環境においてdocker-containerから行うケースは殆どない為、各自のローカル環境に導入要件（php5.4以上）を組み込んでいただく必要がありました。
