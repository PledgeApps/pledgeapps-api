sys = require "sys"
async = require "async"
CharityBetsBet = require "../../lib/data/charitybets-bet.coffee"
CharityBetsBets = require "../../lib/data/charitybets-bets.coffee"
PledgeAppsModel = require "./pledge-apps-model.coffee"

class CharityBetsModel
	@appData: (userId, cb) ->
		async.parallel [(callback) =>
			PledgeAppsModel.leaderboards 'charitybets', 0, (data) ->
				callback null, data
		, (callback) =>
			CharityBetsModel.openBets (data) ->
				callback null, data
		, (callback) =>
			CharityBetsModel.myBets userId, (data) ->
				callback null, data
		], (err, results) =>
			cb {
				leaderboards: results[0],
				publicBets: results[1],
				myBets: results[2]
			}
	@openBets: (cb) ->
		CharityBetsBets.loadOpenPublicBets cb
	@myBets: (userId, cb) ->
		CharityBetsBets.loadUsersBets userId, cb
	@acceptBet: (userId, betId, cb) ->
		#todo make sure the user can accept this bet
		CharityBetsBet.load betId, (bet) ->
			bet.accept userId, cb
		#log a message
	@rejectBet: (userId, betId, cb) ->
		#todo make sure the user can reject this bet
		ChartBetsBet.load betId, (bet) ->
			bet.reject userId, cb
		#log a message
	@userDetails: (userId, cb) ->
		console.log userId
		async.parallel [(callback) =>
			PledgeAppsModel.publicUserData userId, (data) ->
				callback null, data
		, (callback) =>
			CharityBetsModel.myBets userId, (data) ->
				callback null, data
		], (err, results) =>
			result = results[0][0]
			result.bets = results[1]
			cb result
module.exports = CharityBetsModel