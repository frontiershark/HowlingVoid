import path from 'node:path';

import { defineConfig } from '@rspack/cli';
import rspack, { type StatsOptions } from '@rspack/core';

function createStats(verbose: boolean): StatsOptions {
  return {
    assets: verbose,
    builtAt: verbose,
    cached: false,
    children: false,
    chunks: false,
    colors: true,
    entrypoints: true,
    hash: false,
    modules: false,
    performance: false,
    timings: verbose,
    version: verbose,
  };
}

const dirname = path.resolve();

const entries = {
  overlay: './src/overlay',
  'chat-panel': './src/chat-panel',
  'chat-input': './src/chat-input',
};

export default defineConfig({
  context: dirname,
  devtool: false,
  entry: entries,
  mode: 'production',
  module: {
    rules: [
      {
        test: /\.([tj]s(x)?|cjs)$/,
        type: 'javascript/auto',
        use: [
          {
            loader: 'builtin:swc-loader',
            options: {
              jsc: {
                parser: {
                  syntax: 'typescript',
                  tsx: true,
                },
                transform: {
                  react: {
                    runtime: 'automatic',
                  },
                },
              },
            },
          },
        ],
      },
      {
        test: /\.(s)?css$/,
        type: 'javascript/auto',
        use: [
          rspack.CssExtractRspackPlugin.loader,
          'css-loader',
          {
            loader: 'sass-loader',
            options: {
              api: 'modern-compiler',
              implementation: 'sass-embedded',
            },
          },
        ],
      },
      {
        test: /\.(png|jpg)$/,
        type: 'asset/resource',
        generator: {
          filename: '[name][ext]',
        },
      },
      {
        test: /\.svg$/,
        oneOf: [
          {
            issuer: /\.(s)?css$/,
            type: 'asset/inline',
          },
          {
            type: 'asset/resource',
          },
        ],
        generator: {
          filename: '[name][ext]',
        },
      },
    ],
  },
  optimization: {
    emitOnErrors: false,
  },
  output: {
    path: path.resolve(dirname, '../compiled'),
    filename: '[name]/[name].bundle.js',
    chunkFilename: '[name]/[name].bundle.js',
    chunkLoadTimeout: 15000,
    publicPath: '/',
    assetModuleFilename: '[name][ext]',
  },
  performance: {
    hints: false,
  },
  plugins: [
    new rspack.CssExtractRspackPlugin({
      chunkFilename: '[name]/[name].bundle.css',
      filename: '[name]/[name].bundle.css',
    }),
    new rspack.EnvironmentPlugin({
      NODE_ENV: 'production',
    }),
    new rspack.CircularDependencyRspackPlugin({
      failOnError: true,
      exclude: /node_modules/,
    }),
    new rspack.IgnorePlugin({
      resourceRegExp: /\.test\.tsx?$/,
      contextRegExp: /__mocks__/,
    }),
  ],
  resolve: {
    extensions: ['.tsx', '.ts', '.js', '.jsx'],
    alias: {
      ...Object.fromEntries(
        Object.entries(entries).map(([name, entry]) => [
          name,
          path.resolve(dirname, entry),
        ]),
      ),
      common: path.resolve(dirname, './src/common'),
    },
  },
  stats: createStats(true),
  target: ['web', 'browserslist:edge >= 123'],
});
