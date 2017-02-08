module.exports = {
  entry: `${__dirname}/src/index.js`,
  output: {
    filename: 'bundle.js',
    path: `${__dirname}/dist`,
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
      loaders: ['babel-loader'],
    }, {
      test: /\.html$/,
      loader: 'raw',
    }, {
      test: /\.css$/,
      loaders: ['style-loader', 'css-loader'],
    }],
  }
};
