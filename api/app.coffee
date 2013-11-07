sys = require "sys"
http = require "http"
path = require "path"
express = require "express"
#Error = require '../lib/data/error.coffee'
PledgeAppsRoute = require "./routes/pledge-apps-route.coffee"
CharityBetsRoute = require "./routes/charity-bets-route.coffee"


app = express()

app.configure () ->
	app.set 'port', process.env.PORT || 3101
	app.set 'views', __dirname + '/views'
	app.set 'view engine', 'jade'
	app.locals._ = require "underscore"
	app.use express.favicon(__dirname + '/public/favicon.ico')
	app.use express.bodyParser
		uploadDir: __dirname + "/tmp",
		keepExtensions: true
	app.use express.logger('dev')
	app.use express.methodOverride()
	app.use app.router
	app.use require('stylus').middleware(__dirname + '/public')
	app.use express.static(path.join(__dirname, 'public'))
#	app.use (err, req, res, next) ->
#		userId = 0
#		userId = req.user.id if req.user?
#		Error.log userId,err.stack,req.url, () ->
#		console.log "Caught exception: " + err
#		res.send(500, 'An unexpected error occurred.  Please return to the home page and try again.');

app.get "/", PledgeAppsRoute.v1
app.get "/charitybets/", CharityBetsRoute.v1


http.createServer(app).listen app.get('port'), ()->
  console.log "Express server listening on port " + app.get('port')

#process.on "uncaughtException", (err) ->
#	Error.log 0,err,'', () ->
#		console.log "Caught exception: " + err
