# nodejsのイメージから作成
FROM arm64v8/node:10.18.1-alpine3.11
WORKDIR /opt

# ビルドに必要なパッケージのインストール
RUN apk --no-cache --virtual .del add curl git python make g++ wget openssl

# growiのダウンロード
RUN git clone https://github.com/weseek/growi growi
WORKDIR /opt/growi
RUN git checkout -b v3.6.3 refs/tags/v3.6.3

# 必要なモジュールの取得
RUN yarn --network-timeout 1000000

# ビルド
RUN npm run build:prod

# dockerizeのインストール
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-armhf-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-armhf-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-armhf-$DOCKERIZE_VERSION.tar.gz

RUN apk del .del