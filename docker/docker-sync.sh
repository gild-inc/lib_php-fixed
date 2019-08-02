#!bin/bash

if [ $# -eq 0 ]; then
    echo "引数は必須です。" 1>&2
    echo "'. docker-sync.sh up'   ->  docker-syncを利用してコンテナの起動を行います。" 1>&2
    echo "'. docker-sync.sh stop' ->  コンテナの停止を行います。" 1>&2
    echo "'. docker-sync.sh down' ->  コンテナ及びVolumesのプロセスを終了します。" 1>&2
    return
fi

if [ $# -ne 1 ]; then
    echo "引数は複数指定できません。" 1>&2
    return
fi

# docker-syncがインストールされていなかったら、インストールを行う。
which docker-sync >/dev/null 2>&1
if [ "$?" -eq 1 ] ; then
    echo 'お使いのPCにdocker-syncをインストールします。'
    # todo::macのある漫画喫茶探してエラーがでないように試行錯誤試して書く。
fi

if [ $1 = up ]; then
    rm -rf .docker-sync/
    rm -rf servers/web/var/
    rm -rf servers/app/var/
    docker-sync start
    docker-compose up -d
fi

if [ $1 = stop ]; then
    rm -rf .docker-sync/
    rm -rf servers/web/var/
    rm -rf servers/app/var/
    docker-compose stop
fi

if [ $1 = down ]; then
    rm -rf .docker-sync/
    rm -rf servers/web/var/
    rm -rf servers/app/var/
    rm -rf servers/db/etc/
    rm -rf servers/db/var/
    # docker-compose.yml に記載のコンテナと元となったimageの削除。
    docker-compose down --rmi all

    # コンテナの全削除
    # docker ps -aq | xargs docker rm
    # イメージの全削除
    # docker images -aq | xargs docker rmi --force
    # ボリュームの全削除
    # docker volume rm $(docker volume ls -qf dangling=true)
    # 停止コンテナとイメージ及び未使用のイメージとボリュームの削除
    # docker system prune
fi