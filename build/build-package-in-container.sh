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
rm -rf .nuxt /dist/.nuxt /dist/lambda-package.zip /dist/assets.zip

# 環境変数確認
echo NODE_ENV=${NODE_ENV}
echo BASE_PATH=${BASE_PATH}
echo ASSETS_URL=${ASSETS_URL}
echo PUBLIC_API_BASE_URL=${PUBLIC_API_BASE_URL}
echo SERVER_API_BASE_URL=${SERVER_API_BASE_URL}

# nuxt と lambda のソースをビルド
yarn build

# 成果物を圧縮用ディレクトリに移動して zip アーカイブ
cd /dist
mv /var/task/.nuxt ./
zip -rq lambda-package.zip .nuxt/dist/lambda.js .nuxt/dist/server node_modules
zip -rq assets.zip .nuxt/dist/client

# マウントしているはずのホストマシンのディレクトリに格納
mv lambda-package.zip assets.zip /var/task/

echo lambda-package.zip, assets.zip created.
