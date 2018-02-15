const webpack = require("webpack");
const ExtractTextPlugin = require("extract-text-webpack-plugin");

// const VENDOR_LIBS = [
//   "semantic"
// ];

module.exports = {
  entry: {
    app: "./js/app.js",
  },

  output: {
    path: __dirname + "/../priv/static",
    filename: "js/[name].js"
  },
  module: {
    rules: [
      {
        test: /\.less$/,
        use: [
          { loader: "style-loader"},
          { loader: "css-loader"},
          {
            loader: "postcss-loader",
            options: {
              plugins: () => [require('autoprefixer')]
            }
          },
          { loader: "less-loader"}
        ]
      },
      {
        test: /\.css$/,
        use: ExtractTextPlugin.extract({
          fallback: "style-loader",
          use: "css-loader"
        })
      },
      {
        test: /\.js$/,
        use: "babel-loader",
        exclude: /(node_moduels|bower_components)/
      },
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: "file-loader",
        query: {
          name: "fonts/[hash].[ext]",
          mimetype: "application/font-woff"
        }
      },
      {
        test: /\.(eot|svg|ttf)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: "file-loader",
        query: {
          name: "fonts/[hash].[ext]"
        }
      },
      {
        test: /\.(png|jpg|jpeg)$/,
        loader: "file-loader",
        query: {
          name: "images/[hash].[ext]"
        }
      }
    ]
  },
  plugins: [
    new webpack.LoaderOptionsPlugin({
      minimize: true,
      debug: false,
      options: {
        postcss: [
          () => require("autoprefixer")
        ]
      }
    }),
    new webpack.ProvidePlugin({
      $: "jquery",
      jQuery: "jquery",
      "window.jQuery": "jquery"
    }),
    new ExtractTextPlugin("css/app.css")
  ]
};
