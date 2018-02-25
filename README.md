# nodenv-package-json-engine

This is a plugin for [nodenv](https://github.com/nodenv/nodenv)
that detects the Node version based on the [`engines`](https://docs.npmjs.com/files/package.json#engines) field of the current tree's `package.json` file. The `$NODENV_VERSION` environment variable (set with `nodenv shell`) and `.node-version` files still take precedence.

When `engines` is configured with a range this plugin chooses the greatest installed version matching the range, or exits with an error if none match.

[![Build Status](https://travis-ci.org/nodenv/nodenv-package-json-engine.svg?branch=master)](https://travis-ci.org/nodenv/nodenv-package-json-engine)

## Installation

### Installing with Git

```sh
$ git clone https://github.com/nodenv/nodenv-package-json-engine.git $(nodenv root)/plugins/nodenv-package-json-engine
```

### Installing with Homebrew

Mac OS X users can install [many nodenv plugins](https://github.com/nodenv/homebrew-nodenv) with [Homebrew](http://brew.sh).

*This is the recommended method of installation if you installed nodenv with
Homebrew.*

```sh
$ brew tap nodenv/nodenv
$ brew install nodenv-package-json-engine
```

## Usage

Once you've installed the plugin you can verify that it's working by `cd`ing into a project that has a `package.json` file with `engines` and does not have a `.node-version` file.  From anywhere in the project's tree, run `nodenv which node`.

## Contributing

To run tests, install [bats](https://github.com/sstephenson/bats) and [nodenv](https://github.com/nodenv/nodenv), then run `bats test`  in the base directory of this plugin

## Credits

`package.json` inspection and SemVer integration heavily inspired by nvmish [[1]](https://github.com/goodeggs/homebrew-delivery-eng/blob/master/nvmish.sh) [[2]](https://gist.github.com/assaf/ee377a186371e2e269a7).

Nodenv plugin hooks integration and tests heavily inspired by [rbenv-bundler-ruby-version](https://github.com/aripollak/rbenv-bundler-ruby-version).

Shell semver range support provided by [sh-semver](https://github.com/qzb/sh-semver).
