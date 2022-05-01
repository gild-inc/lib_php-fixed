#!bin/bash

# コミット時のメッセージアーティファクト
COMMIT_EDITMSG=$1
# `git commit`       => $MODEは、`template`。
# `git commit -m ""` => $MODEは、空文字か`message`。
MODE=$2
if [ "$MODE" = "" ] || [ "$MODE" = "message" ] ; then
  # ブランチ名から数字または小文字大文字アルファベットまたはアンダースコアまたはハイフンを抜き出す。
  TICKET_NUMBER=`git branch | grep "*" | awk '{print $2}' | perl -nE 'say $& if /[0-9a-zA-Z_-]+$/'`
  if [ "$TICKET_NUMBER" != "" ]; then
    # 変更を加える前に退避。
    mv $COMMIT_EDITMSG $COMMIT_EDITMSG.tmp
    # 退避ファイルの１行目先頭にチケット番号を付与して、本来のファイルに上書きする
    sed '1s/^/'"[$TICKET_NUMBER]"' /g' $COMMIT_EDITMSG.tmp >> $COMMIT_EDITMSG
  fi
fi
