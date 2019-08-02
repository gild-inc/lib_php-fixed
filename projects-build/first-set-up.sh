#!bin/bash

. config/.env.vendor

if [ ! $PROJECT_NAME ]; then
    echo "config/.env.vendorにPROJECT_NAMEが設定されていません。"
    echo "以下の {project_name}をconfig/.env.vendorのPROJECT_NAMEに設定してください。"
    echo ~/_projects/
    echo "┣━ {project_name}"
    echo "┃  ┣━ docker（既にある）"
    echo "┃  ┣━ projects"
    echo "┃  ┃   ┣━ api（これから作ろうとしている）"
    echo "┃  ┃   ┗━ view（これから作ろうとしている）"
    return
fi

# プロジェクト本体のinstall
mkdir -p ~/_projects/$PROJECT_NAME/projects/api
mkdir -p ~/_projects/$PROJECT_NAME/projects/view

if [ -z "$(ls ~/_projects/$PROJECT_NAME/projects/api)" ]; then
    git clone git@github.gild-inc:gild-inc/$PROJECT_NAME-api.git ~/_projects/$PROJECT_NAME/projects/api
    cd ~/_projects/$PROJECT_NAME/projects/api
    composer update
    cp ~/_projects/$PROJECT_NAME/projects/api/.env.example ~/_projects/$PROJECT_NAME/projects/api/.env
    php ~/_projects/$PROJECT_NAME/projects/api/artisan key:generate
else
    echo -e "\033[0;35m fatal: destination path ' ~/_projects/$PROJECT_NAME/projects/api ' already exists and is not an empty directory.\033[0;39m"
fi

if [ -z "$(ls ~/_projects/$PROJECT_NAME/projects/view)" ]; then
    git clone git@github.gild-inc:gild-inc/$PROJECT_NAME-view.git ~/_projects/$PROJECT_NAME/projects/view
    cd ~/_projects/$PROJECT_NAME/projects/view
    composer update
    cp ~/_projects/$PROJECT_NAME/projects/view/.env.example ~/_projects/$PROJECT_NAME/projects/view/.env
    php ~/_projects/$PROJECT_NAME/projects/view/artisan key:generate
    npm install
    npm run dev
else
    echo -e "\033[0;35m fatal: destination path ' ~/_projects/$PROJECT_NAME/projects/view ' already exists and is not an empty directory.\033[0;39m"
fi

cd ~/_projects/$PROJECT_NAME/docker

# 一度作った証明書は削除しない。
mkdir -p ~/_projects/$PROJECT_NAME/docker/servers/web/etc/nginx/ssl
#cd servers/web/etc/nginx/ssl
if [ -z "$(ls ~/_projects/$PROJECT_NAME/docker/servers/web/etc/nginx/ssl)" ]; then
    openssl genrsa 2048 > ~/_projects/$PROJECT_NAME/docker/servers/web/etc/nginx/ssl/server.key
    openssl req -new -key ~/_projects/$PROJECT_NAME/docker/servers/web/etc/nginx/ssl/server.key -subj "/C=JP/ST=Tokyo/L=Shibuya-ku/O=GILD,Inc./OU=System/CN=$HOST" > ~/_projects/$PROJECT_NAME/docker/servers/web/etc/nginx/ssl/server.csr
    openssl x509 -in ~/_projects/$PROJECT_NAME/docker/servers/web/etc/nginx/ssl/server.csr -days 3650 -req -signkey ~/_projects/$PROJECT_NAME/docker/servers/web/etc/nginx/ssl/server.key > ~/_projects/$PROJECT_NAME/docker/servers/web/etc/nginx/ssl/server.crt
    chmod 400 ~/_projects/$PROJECT_NAME/docker/servers/web/etc/nginx/ssl/server.key
    rm -rf ~/_projects/$PROJECT_NAME/docker/servers/web/etc/nginx/ssl/server.csr
fi

# プロジェクト本体を動かす為、dockerの起動
. docker-sync.sh up

# 権限の変更
chmod -R 777 ~/_projects/$PROJECT_NAME/projects/api/storage
chmod -R 777 ~/_projects/$PROJECT_NAME/projects/view/storage