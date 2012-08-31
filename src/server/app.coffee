express = require 'express'
fs      = require 'fs'
exec    = require('child_process').exec
routes  = require './routes/routes'
http    = require 'http'
app     = express()
cake    = './node_modules/coffee-script/bin/cake'


# Maybe it's better to have a cfg for this kinda stuff
app.settings.env = 'development'

# Configure globally
app.configure ->
  app.set 'port', process.env.PORT || 8888
  app.set 'views', './views'
  app.set 'view engine', 'jade'

  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static('./compiled/client')

# Configure environemnts
app.configure 'development', ->
  app.locals.pretty = true
  app.use express.logger 'dev'
  app.use express.errorHandler()

app.configure 'production', ->
  exec cake + ' ' + app.settings.env
  logFile = fs.createWriteStream('./log.log', flags: 'w')
  app.use express.logger stream: logFile, 'dev'
  
# Routes
app.get '/', routes.index
app.get '/blog', routes.blog
app.get '/about', routes.about

server = http.createServer(app)
server.listen app.get('port'), ->
  console.log 'Listening on port ' + app.get('port') + ', Env: ' + app.settings.env
