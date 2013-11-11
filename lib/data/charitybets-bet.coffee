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
	@load: ( id, cb ) ->
		CharityBetBase.load id, (data) ->
			cb CharityBet.cast(data)
	accept: (userId, cb) ->
		@acceptanceDate = new Date
		@acceptorId = userId
		@status = 'accepted'
		@save cb
	reject: (userId, cb) ->
		@acceptanceDate = new Date
		@acceptorId = userId
		@status = 'cancelled'
		@save cb
	admitDefeat: (userId, cb) ->
		@winnerId = (if (userId==@submitterId) then @acceptorId else @submitterId)
		@status = 'settled'
		@save cb

module.exports = CharityBet