#!/bin/sh
# For production.
# pumaのipdとsocketファイル用のディレクトリを作成する
mkdir -p /app/tmp/sockets && mkdir -p /app/tmp/pids
# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid
