const path = require('path')

module.exports = {
  mode: 'production',
  entry: {
    lambda: path.resolve(__dirname, './server/lambda.ts'),
  },
  output: {
    path: path.resolve(__dirname, './.nuxt/dist'),
    filename: '[name].js',
    libraryTarget: 'commonjs',
  },
  target: 'node',
  externals: ['nuxt-start'],
  module: {
    rules: [
      {
        test: /\.ts$/,
        use: 'ts-loader',
        exclude: /node_modules/,
      },
    ],
  },
  resolve: {
    extensions: ['.ts', '.js'],
  },
}
