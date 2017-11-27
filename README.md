#Express 3 boilerplate

This boilerplate is the product of experimenting with Node.js. It aims to provide basic scaffolding for Express 3 projects that include client-side.


## Documentation


### Install dependencies

`$ npm install`


### Getting started

The `src` folder is meant to be the working directory. Corresponding files are compiled to the `compiled` directory.


### Run Watcher

The Cakefile includes several tasks for certain environments. To compile Sass and CoffeeScript on the fly start the appropriate watcher by cd'ing into

`./node_modules/coffee-script/bin/`

You are able to run tasks like so

`$ cake dev`


### Start the server

`$ node server`


### Run tests

For testing purpose I used [mocha](http://mochajs.org/) and [should.js](https://github.com/visionmedia/should.js) for BDD style assertions. Sample test included.

Test client-side code

`$ cake testClient`

You could also run all tests

`$ npm test`


### Addendum

Check out the [Cakefile](https://github.com/jonykrause/node-express-coffee-jade-sass-mocha/blob/master/Cakefile) for more build tasks.












