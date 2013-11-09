sys = require "sys"
Config = require "../../config.coffee"
CharityBetsModel = require "../models/charity-bets-model.coffee"
PledgeAppsModel = require "../models/pledge-apps-model.coffee"

class CharityBetsRoute
	@v1: (req, res) ->
		userKey = req.query["k"]
		if userKey?
			PledgeAppsModel.userId userKey, (userId) ->
				CharityBetsRoute.processRequest req, res, userId
		else
			CharityBetsRoute.processRequest req, res, 0
	
	@processRequest: (req, res, userId) ->
		action = req.query["a"]

		res.setHeader 'Content-Type', 'application/json'
		res.setHeader 'Access-Control-Allow-Origin', '*'

		if action=='appData'
			CharityBetsModel.appData userId, (data) ->
				res.end JSON.stringify(data)
		else if action=='myBets'
			CharityBetsModel.myBets userId, (data) ->
				res.end JSON.stringify(data)
		else if action=='openBets'
			CharityBetsModel.openBets (data) ->
				res.end JSON.stringify(data)
		else if action=='userDetails'
			tmpUserId = req.query["userId"]
			CharityBetsModel.userDetails tmpUserId, (data) ->
				res.end JSON.stringify(data)
		else if action=='leaderboards'
			PledgeAppsModel.leaderboards 'charitybets', userId, (data) ->
				res.end JSON.stringify(data)
		else if action=='winnersLeaderboard'
			PledgeAppsModel.winnersLeaderboard 'charitybets', userId, (data) ->
				res.end JSON.stringify(data)
		else if action=='giversLeaderboard'
			PledgeAppsModel.giversLeaderboard 'charitybets', userId, (data) ->
				res.end JSON.stringify(data)
module.exports = CharityBetsRoute