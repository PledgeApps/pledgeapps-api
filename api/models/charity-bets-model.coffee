sys = require "sys"
async = require "async"
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