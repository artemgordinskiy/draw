module.exports = {
  entry: './src/main.js',
  output: {
    filename: 'bundle.js',
    path: './dist',
  },
  module: {
    // preLoaders: [{
    //   test: /\.js$/,
    //   exclude: /node_modules/,
    //   loader: 'eslint-loader'
    // }],
    loaders: [{
      test: /\.js$/,
      exclude: /(\.test.js$|node_modules)/,
      loaders: ['babel'],
    }, {
      test: /\.html$/,
      loader: 'raw',
    }],
  }
};
