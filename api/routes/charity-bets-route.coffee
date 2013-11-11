sys = require "sys"
Config = require "../../config.coffee"
CharityBetsModel = require "../models/charity-bets-model.coffee"
PledgeAppsModel = require "../models/pledge-apps-model.coffee"

class CharityBetsRoute
	@actionPost: (req, res) ->
		userKey = req.query["k"]
		PledgeAppsModel.userId userKey, (userId) ->
			CharityBetsRoute.processPost req, res, userId

	@actionGet: (req, res) ->
		userKey = req.query["k"]
		if userKey?
			PledgeAppsModel.user userKey, (user) ->
				CharityBetsRoute.processRequest req, res, user
		else
			CharityBetsRoute.processRequest req, res, 0
	
	@processRequest: (req, res, user) ->
		userId = (if (user==null) then 0 else user.id)
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
		else if action=='acceptBet'
			betId = parseInt(req.query["betId"])
			CharityBetsModel.acceptBet user, betId, () ->
				res.end "{}"
		else if action=='rejectBet'
			betId = parseInt(req.query["betId"])
			CharityBetsModel.rejectBet user, betId, () ->
				res.end "{}"
		else if action=='claimVictory'
			betId = parseInt(req.query["betId"])
			CharityBetsModel.claimVictory user, betId, () ->
				res.end "{}"
		else if action=='admitDefeat'
			betId = parseInt(req.query["betId"])
			CharityBetsModel.admitDefeat user, betId, () ->
				res.end "{}"
		else if action=='userDetails'
			tmpUserId = parseInt(req.query["userId"])
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
		


	@processPost: (req, res, userId) ->
		res.end

module.exports = CharityBetsRoute