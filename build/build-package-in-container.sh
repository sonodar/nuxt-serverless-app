#!/bin/bash -e

export NODE_ENV=${NODE_ENV:-production}

if [[ ! -x /yarn/.yarn/bin/yarn ]]; then
  curl -o- -L https://yarnpkg.com/install.sh | bash
  rm -rf /yarn/.yarn && mv /root/.yarn/ /yarn/
fi
export PATH=/yarn/.yarn/bin:$PATH

# NODE_ENV=production だと devDependencies がインストールされないため
# --production=false を付けないとビルドができない
yarn install --production=false

# Lambda デプロイ用の production モジュールは別ディレクトリにインストール
yarn install --modules-folder /dist/node_modules --production

# cleanup
rm -rf .nuxt /dist/.nuxt /dist/lambda-package.zip

# nuxt と lambda のソースをビルド
yarn build

# 成果物を圧縮用ディレクトリに移動して zip アーカイブ
cd /dist
mv /var/task/.nuxt ./
# TODO: 後に client は除外
zip -rq lambda-package.zip .nuxt/dist/lambda.js .nuxt/dist/server .nuxt/dist/client node_modules

# マウントしているはずのホストマシンのディレクトリに格納
mv lambda-package.zip /var/task/

echo lambda-package.zip created.
