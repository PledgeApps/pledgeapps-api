sys = require "sys"
async = require "async"
Users = require "../../lib/data/users.coffee"
PledgeAppsModel = require "./pledge-apps-model.coffee"

class CharityBetsModel
	@appData: (userId, cb) ->
		async.parallel [(callback) =>
			PledgeAppsModel.leaderboards 'charitybets', 0, (data) ->
				callback null, data
		], (err, results) =>
			cb {
				leaderboards: results[0]
			}
module.exports = CharityBetsModel