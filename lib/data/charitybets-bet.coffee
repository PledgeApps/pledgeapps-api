sys = require("sys")
CharityBetsBetBase = require("./base/charitybets-bet-base.coffee")
Global = require "../global.coffee"

class CharityBetsBet extends CharityBetsBetBase
	@cast = (baseClass) ->
		if baseClass != null
			baseClass.__proto__ = CharityBet::
		return baseClass
	@loadRow = (row) ->
		 CharityBetsBet.cast(CharityBetsBetBase.loadRow row)
	@loadFromQuery = ( query, params, cb ) ->
		CharityBetsBetBase.loadFromQuery query, params, (data) ->
			cb CharityBetsBet.cast(data)
	@load: ( id, cb ) ->
		CharityBetsBetBase.load id, (data) ->
			cb CharityBetsBet.cast(data)
	@post: (submitterId, acceptorId, amount, title, eventDate, cb) ->
		bet = new CharityBetsBet()
		bet.submitterId = submitterId
		bet.acceptorId = acceptorId
		bet.amount = amount
		bet.title = title
		bet.eventDate = eventDate
		bet.save cb
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

module.exports = CharityBetsBet