sys = require("sys")
Global = require("../../global.coffee")

class CharitybetsBetBase
	constructor: ( @id, @submitterId, @acceptorId, @submissionDate, @eventDate, @acceptanceDate, @title, @amount, @status, @winnerId, @tags ) ->
		@id = 0 if not @id?
	save: (cb) =>
		columns = { submitter_id: @submitterId, acceptor_id: @acceptorId, submission_date: @submissionDate, event_date: @eventDate, acceptance_date: @acceptanceDate, title: @title, amount: @amount, status: @status, winner_id: @winnerId, tags: @tags }
		if @id == 0
			Global.query "INSERT INTO charitybets_bets SET ?", columns, (err, result) =>
				sys.puts err if err?
				@id=result.insertId
				cb()
		else
			Global.query "UPDATE charitybets_bets SET ? WHERE id = " + @id, columns, cb
	@load = ( id, cb ) ->
		Global.query "SELECT * FROM charitybets_bets where id = " + id, null, (err, rows) =>
			result = CharitybetsBetBase.loadRow rows[0] if (rows.length>0)
			cb(result);
	@delete = ( id, cb ) ->
		Global.query "DELETE FROM charitybets_bets where id = " + id, null, (err, rows) =>
			cb();
	@loadRow = (row) ->
		return new CharitybetsBetBase row.id, row.submitter_id, row.acceptor_id, row.submission_date, row.event_date, row.acceptance_date, row.title, row.amount, row.status, row.winner_id, row.tags
	@loadFromQuery = ( query, params, cb ) ->
		Global.query query, params, (err, rows) =>
			sys.puts err if err?
			result = null
			result = CharitybetsBetBase.loadRow rows[0] if rows.length>0
			cb(result);

module.exports = CharitybetsBetBase