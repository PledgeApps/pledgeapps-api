CharityBetsBetsBase = require "./base/charitybets-bets-base.coffee"
Global = require "../global.coffee"
sys = require "sys"


class CharityBetsBets extends CharityBetsBetsBase
	getIds: () =>
		result = []
		@forEach (bet) =>
			result.push bet.id
		result
	@cast: (baseClass) ->
		baseClass.__proto__ = CharityBetsBets::
		baseClass
	@loadFromQuery: ( query, params, cb ) ->
		CharityBetsBetBase.loadFromQuery query, params, (data) ->
			cb CharityBetsBet.cast(data)
	@loadOpenPublicBets: (cb) ->
		sql = "select b.*, u1.user_name as submitter_name, u2.user_name as acceptor_name
		 from charitybets_bets b
		 left outer join users u1 on u1.id=b.submitter_id
		 left outer join users u2 on u2.id=b.acceptor_id
		 where status='open' and event_date >= now()
		 order by event_date"
		Global.query sql, {}, (err, rows) ->
			cb rows
	@loadUsersBets: (userId, cb) ->
		sql = "select b.*, u1.user_name as submitter_name, u2.user_name as acceptor_name
		 from charitybets_bets b
		 left outer join users u1 on u1.id=b.submitter_id
		 left outer join users u2 on u2.id=b.acceptor_id
		 where submitter_id=" + userId + " or acceptor_id=" + userId + "
		 order by event_date desc"
		Global.query sql, {}, (err, rows) ->
			cb rows
module.exports = CharityBetsBets
