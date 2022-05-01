#!bin/bash

if [ $# -eq 0 ]; then
  echo "引数は必須です。"
  echo "'. execution.sh commit'   ->  コミット前にコーディングチェックを行います。"
  echo "'. execution.sh push'     ->  プッシュ前にコーディングチェックを行います。コミット前のチェックは行いません。"
  exit 1
fi

if [ "$1" != "commit" ] && [ "$1" != "push" ]; then
  echo "引数が規定の値ではありません。"
  exit 1
fi

GIT_HOOK_DIR=.git/hooks
mkdir -p $GIT_HOOK_DIR
# 念の為バックアップして、動作の一貫性担保の為削除。
if [ "$1" = "commit" ] && [ -e $GIT_HOOK_DIR/pre-push ]; then
  cp -f $GIT_HOOK_DIR/pre-push $GIT_HOOK_DIR/pre-push.buckup
  rm -rf $GIT_HOOK_DIR/pre-push
fi
if [ "$1" = "push" ] && [ -e $GIT_HOOK_DIR/pre-commit ]; then
  cp -f $GIT_HOOK_DIR/pre-commit $GIT_HOOK_DIR/pre-commit.buckup
  rm -rf $GIT_HOOK_DIR/pre-commit
fi
# 「main.shを呼び出す処理」を対象のトリガースクリプトとして複製。
cp -f vendor/gild/php-fixed/src/repository/git/hooks/pre-$1 $GIT_HOOK_DIR

# バックアップを取って、消去する。
USER_CONFIG_DIR=.git_hooks/pre-$1
mkdir -p $USER_CONFIG_DIR
if [ -e $USER_CONFIG_DIR/main.sh ]; then
  cp -f $USER_CONFIG_DIR/main.sh $USER_CONFIG_DIR/main.sh.buckup
  rm -rf $USER_CONFIG_DIR/main.sh
fi
# 自由に定義して使えるようにチェックスクリプトとルール定義をポジトリに含めてもらうようにする為に複製。
cp -f vendor/gild/php-fixed/src/repository/git-hooks/main.sh $USER_CONFIG_DIR

# バージョンアップ差分整合性対応
if [ -e phpcs-rule.xml ]; then
  cp -f phpcs-rule.xml phpcs.xml
  rm -rf phpcs-rule.xml
fi
cp -f vendor/gild/php-fixed/src/repository/phpcs.xml .
