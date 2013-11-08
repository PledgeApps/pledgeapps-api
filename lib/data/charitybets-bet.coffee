sys = require("sys")
CharityBetBase = require("./base/charitybets-bet-base.coffee")
Global = require "../global.coffee"

class CharityBet extends CharityBetBase
	@cast = (baseClass) ->
		if baseClass != null
			baseClass.__proto__ = CharityBet::
		return baseClass
	@loadRow = (row) ->
		 CharityBet.cast(CharityBetBase.loadRow row)
	@loadFromQuery = ( query, params, cb ) ->
		CharityBetBase.loadFromQuery query, params, (data) ->
			cb CharityBet.cast(data)
module.exports = CharityBet