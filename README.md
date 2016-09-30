## Prerequisites

The project is built and tested with [Grunt][grunt]. Front-end dependencies are managed with [Bower][bower]. Both of those are Node libraries so you will need Node. The easiest way to install *that* on OSX is using [Homebrew][homebrew]. CSS is built with [Compass][compass]. Given all that, here's how to install all of those things:

Homebrew
: `ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go/install)"`
Node
: `brew install node`
Grunt
: `npm install -g grunt-cli`
Bower
: `npm install -g bower`
Compass
: `gem install compass`

## Installation

Before running the tests or the app you need to install the dependencies. There are build-time dependencies installed with *npm* and run-time (front-end) dependencies installed with Bower.

	npm install
	bower install

## Running tests

Tests are written with [Jasmine][jasmine] and run with [Karma][karma].

	grunt test

This produces terminal output and a JUnit compatible XML report.

## Running the app

	grunt serve

Then point your browser at *http://localhost:9000/*. Grunt watches for changes and will automatically reload the browser.

## Building for deployment

	grunt build

This produces build artifacts in `dist/`.

## Building into the iOS app

* In the *mycircle-smartregister-web* project do `grunt build`.
* Switch over to the *mycircle-smartregister-ios* project and do `./update-web`.
* Ensure you're on the correct branch and do `git pull` to get make sure you're working with the latest code.
* You should see a Git status output with a list of modified files.
* Commit and push the updated files.

## Environments

By default the app points at the staging API *http://staging-platform-mycircleinc.azurewebsites.net*. To point at a different environment add `?baseURL=<url>` **after any hash fragment in the URL**. This will get stored in local storage so you only need to do it once.

To clear settings held in local storage open up the JavaScript console and run:

	localStorage.clear()

This will clear the API base URL and stored credentials.

[grunt]:http://gruntjs.com
[bower]:http://bower.io
[homebrew]:http://brew.sh
[jasmine]:https://jasmine.github.io/
[karma]:http://karma-runner.github.io/0.10/index.html
[compass]:http://compass-style.org/
