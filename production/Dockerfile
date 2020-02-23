FROM node:12.14.0-alpine3.11 as node
FROM ruby:2.6.5-alpine3.11 as ruby
MAINTAINER undrthemt@gmail.com
# For production.
# ### イメージを小さくするため以下を行っています。
# * マルチステージでnode, yarnをコピー
# * RUNのコマンドチェーンによるレイヤーの最小化
# * no-cacheフラグの利用や不要なキャッシュファイルの削除
ENV ON_PRODUCTION_DOCKER true
ENV RAILS_ENV production
ENV NODE_ENV production

ENV YARN_VERSION 1.21.1
COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/include/node /usr/local/include/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node /opt/yarn-v$YARN_VERSION /opt/yarn
COPY --from=node /usr/local/bin/node /usr/local/bin/
RUN ln -s /usr/local/bin/node /usr/local/bin/nodejs \
    && ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
    && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
    && ln -s /opt/yarn/bin/yarnpkg /usr/local/bin/yarnpkg

RUN mkdir -p /app

WORKDIR /app
ADD . /app

ENV BUNDLER_VERSION 2.1.3
RUN apk update -qq \
    # build-dependsで仮名をつけておいて後で削除する
    && apk add --no-cache --virtual build-depends build-base \
    && apk add --no-cache tzdata libxml2-dev libxslt-dev postgresql-dev \
    # timezoneをJSTに変更
    && cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    # bundlerをインストールしてproductionのみインストールする
    && gem install bundler -v $BUNDLER_VERSION \
    && bundle config set without 'development test' \
    # nokogiriをbuildできるようにシステムライブラリを使うフラグを渡す
    && bundle config build.nokogiri --use-system-libraries \
    && bundle install \
    && apk del --purge build-depends \
    # bundle installで入る不要なキャッシュを削除
    && rm -rf /usr/local/lib/ruby/gems/2.6.0/cache \
    && rm -rf /root/.bundle/cache/compact_index/*  \
    && rm -rf /var/cache/* \
    && rm -rf /usr/local/bundle/cache \
    # yarn.lockファイルからproductionのみインストール
    && yarn install --production --frozen-lockfile --check-files \
    && rails assets:precompile

# Add a script to be executed every time the container starts.
COPY ./docker/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["sh", "docker/entrypoint.sh"]

EXPOSE 3000
