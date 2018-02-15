const webpack = require("webpack");
const ExtractTextPlugin = require("extract-text-webpack-plugin");

module.exports = [
  {

    name: "css",
    entry: "./css/app.css",
    output: {
      path: __dirname + "/../priv/static",
      filename: "css/style.css"
    },
    module: {
      rules: [
        {
          test: /\.css$/,

          use: ExtractTextPlugin.extract({
               fallback: "style-loader",
               use: ["css-loader"]
              }),
        }
      ]
    },
    plugins: [
      new webpack.LoaderOptionsPlugin({
        minimize: true,
        debug: false,
        options: {
          postcss: [
            ()=>require("autoprefixer"),
          ]
        }
      }),

      new webpack.optimize.UglifyJsPlugin({
        compress: {warnings: false},
        output: {comments: false}
      }),
      new ExtractTextPlugin("css/app.css")
    ]
  },
  {
    name: "semanticUI",
    entry: "./js/app.js",
    output: {
      path: __dirname + "/../priv/static",
      filename: "js/app.js"
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
          test: /\.(png)$/,
          loader: "file-loader",
          query: {
            name: "images/[hash].[ext]"
          }
        },
        {
          test: /\.js$/,
          exclude: /(node_modules|bower_components)/,
          loader: "babel-loader"
        }
      ]
    },
    plugins: [
      new webpack.LoaderOptionsPlugin({
        minimize: true,
        debug: false,
        options: {
          postcss: [
            ()=>require("autoprefixer"),
          ]
        }
      }),
      new webpack.ProvidePlugin({
        $: "jquery",
        jQuery: "jquery",
        "window.jQuery": "jquery"
      }),
      new webpack.optimize.UglifyJsPlugin({
        compress: {warnings: false},
        output: {comments: false}
      })
    ]
  },

];
