sys = require "sys"
async = require "async"
User = require "../../lib/data/user.coffee"
Users = require "../../lib/data/users.coffee"
Config = require "../../config.coffee"

class PledgeAppsModel
	@leaderboards: (appName, userId, cb) ->
		async.parallel [(callback) =>
			PledgeAppsModel.winnersLeaderboard 'charitybets', 0, (data) ->
				callback null, data
		, (callback) =>
			PledgeAppsModel.winnersLeaderboard 'charitybets', userId, (data) ->
				callback null, data
		, (callback) =>
			PledgeAppsModel.giversLeaderboard 'charitybets', 0, (data) ->
				callback null, data
		, (callback) =>
			PledgeAppsModel.giversLeaderboard 'charitybets', userId, (data) ->
				callback null, data
		], (err, results) =>
			cb {
				winners: results[0],
				my_winners: results[1],
				givers: results[2],
				my_givers: results[3]
			}
	@winnersLeaderboard: (appName, userId, cb) ->
		Users.loadWinnersLeaderboard appName, userId, (data) ->
			cb data
	@giversLeaderboard: (appName, userId, cb) ->
		Users.loadGiversLeaderboard appName, userId, (data) ->
			cb data
	@userId: (privateKey, cb) ->
		User.loadByPrivateKey privateKey, (user) ->
			cb user.id
module.exports = PledgeAppsModel