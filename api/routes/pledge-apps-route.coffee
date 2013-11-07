sys = require "sys"
Config = require "../../config.coffee"
PledgeAppsModel = require "../models/pledge-apps-model.coffee"

class PledgeAppsRoute
	@v1: (req, res) ->
		action = req.query["a"]

#		if action=='loaduser'
#			PledgeAppsModel.loaduser query, (data) ->
#				res.end data
module.exports = PledgeAppsRoute