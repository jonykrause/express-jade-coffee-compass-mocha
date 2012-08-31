FILE_ENCODING = 'utf-8'
EOL   = '\n'
fs    = require 'fs'
path  = require 'path'
print = require('util').print
exec  = require('child_process').exec
spawn = require('child_process').spawn


# ========
# PATHS
# ========

appPath     = __dirname
appCompPath = "#{appPath}/compiled"
jsPath      = "#{appCompPath}/client/javascripts"
cssPath     = "#{appCompPath}/client/stylesheets"
toUglifyJS  = "#{appCompPath}/client/javascripts/application.js"
toUglifyCSS = "#{cssPath}/style.css"
uglyJS      = "#{appCompPath}/client/javascripts/application.min.js"
uglyCSS     = "#{cssPath}/style.min.css"

appSrcPath  = "#{__dirname}/src"
coffeePath  = "#{appSrcPath}/client/javascripts"
sassPath    = "#{appSrcPath}/client/stylesheets"
# client Tests
cTestPath   = "#{appCompPath}/client/test"
# server Tests
sTestPath   = "#{appCompPath}/server/test"


# ========
# COMPILER
# ========

sassExec    = 'sass'
coffeeExec  = "#{appPath}/node_modules/coffee-script/bin/coffee"
uglyExec    = "#{appPath}/node_modules/uglify-js/bin/uglifyjs"
mochaExec   = "#{appPath}/node_modules/mocha/bin/mocha"


# ========
# TASKS
# ========


task 'development', ->
  invoke 'watchCoffeeScript'
  invoke 'watchSass'
  invoke 'concatJS'
  invoke 'beautifyCSS'
  # invoke 'watchServerTests'
  # invoke 'watchClientTests'


task 'production', ->
  invoke 'watchCoffeeScript'
  invoke 'watchSass'
  invoke 'concatJS'
  invoke 'beautifyCSS'
  invoke 'minifyJS'
  invoke 'minifyCSS'


task 'test', 'Test Client and Server Scripts', ->
  invoke 'testClient'
  invoke 'testServer'


task 'watchClientTests', ->
  console.log 'Starting Client Test Watcher...'
  Helper.spawnWatcher(mochaExec, [
    '--watch', "#{cTestPath}",
    '--colors',
    '--reporter', 'list',
    '--recursive'
  ])


task 'watchServerTests', ->
  console.log 'Starting Server Test Watcher...'
  Helper.spawnWatcher(mochaExec, [
    '--watch', "#{sTestPath}",
    '--colors',
    '--reporter', 'list',
    '--recursive'
  ])


task 'watchCoffeeScript', ->
  console.log EOL + 'Starting CoffeeScript Watcher...'
  Helper.spawnWatcher(coffeeExec, ['--watch', '--compile', '--output', appCompPath, appSrcPath])


task 'watchSass', ->
  console.log 'Starting Sass Watcher...'
  Helper.spawnWatcher(sassExec, ['--watch', "#{sassPath}:#{cssPath}", '-t', 'expanded'])


task 'testServer', ->
  console.log EOL + 'Running Server Tests...'
  Helper.test(sTestPath)


task 'testClient', ->
  console.log EOL + 'Running Client Tests...'
  Helper.test(cTestPath)


task 'concatJS', ->
  concat = (opts) ->
    console.log 'Concatenating Client JS...'
    fileList = opts.src
    distFile = opts.dest
    out = fileList.map((filePath) -> fs.readFileSync filePath, FILE_ENCODING)
    fs.writeFileSync(distFile, out.join(EOL), FILE_ENCODING)
    console.log " " + distFile + " built."


  concat
    src: [
      #Libs
      "#{jsPath}/libs/jquery-1.8.1.js",

      #Modules
      "#{jsPath}/modules/m1.js",
      "#{jsPath}/modules/m2.js"
    ]
    dest: appCompPath + '/client/javascripts/application.js'


task 'beautifyCSS', ->
  console.log 'Beautifying CSS...'
  cssParser = require('pretty-data').pd
  cssString = fs.readFileSync(toUglifyCSS, FILE_ENCODING)
  beautyfiedCSS = cssParser.css(cssString)
  fs.writeFileSync(toUglifyCSS, beautyfiedCSS, FILE_ENCODING)
  console.log " " + toUglifyCSS + " built."


task 'minifyJS', ->
  console.log 'Minifying JS...'
  uglyfyJS = require("uglify-js")
  jsp = uglyfyJS.parser
  pro = uglyfyJS.uglify
  ast = jsp.parse(fs.readFileSync(toUglifyJS, FILE_ENCODING))
  ast = pro.ast_mangle(ast)
  ast = pro.ast_squeeze(ast)
  fs.writeFileSync(toUglifyJS, pro.gen_code(ast), FILE_ENCODING)
  console.log " " + toUglifyJS + " built."


task 'minifyCSS', ->
  console.log 'Minifying CSS...'
  cssCompiler = require("uglifycss/uglifycss-lib")
  options =
    maxLineLen: 0
    expandVars: false
    cuteComments: true
  uglyfiedCSS = cssCompiler.processFiles([toUglifyCSS], options)
  fs.writeFileSync(toUglifyCSS, uglyfiedCSS, FILE_ENCODING)
  console.log " " + toUglifyCSS + " built."


# =================
# Helper functions
# =================

Helper = {}


Helper.test = (files) ->
  Mocha = require 'mocha'
  mocha = new Mocha(reporter: 'list')
  fs.readdirSync(files).filter((file) ->
    file.substr(-3) is ".js"
  ).forEach (file) ->
    mocha.addFile path.join(files, file)
  mocha.run()


Helper.spawnWatcher = (compiler, flags) ->
  watcher = spawn compiler, flags
  watcher.stdout.on 'data', (data) -> print data.toString()
  watcher.stderr.on 'data', (data) -> print data.toString()
  watcher.on 'exit', (status) -> callback?() if status is 0



