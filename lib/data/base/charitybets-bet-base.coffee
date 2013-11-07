sys = require("sys")
Global = require("../../global.coffee")

class CharitybetsBetBase
	constructor: ( @id, @submitterId, @accepterId, @submissionDate, @eventDate, @acceptanceDate, @title, @amount, @status, @winnerId ) ->
		@id = 0 if not @id?
	save: (cb) =>
		columns = { submitter_id: @submitterId, accepter_id: @accepterId, submission_date: @submissionDate, event_date: @eventDate, acceptance_date: @acceptanceDate, title: @title, amount: @amount, status: @status, winner_id: @winnerId }
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
		return new CharitybetsBetBase row.id, row.submitter_id, row.accepter_id, row.submission_date, row.event_date, row.acceptance_date, row.title, row.amount, row.status, row.winner_id
	@loadFromQuery = ( query, params, cb ) ->
		Global.query query, params, (err, rows) =>
			sys.puts err if err?
			result = null
			result = CharitybetsBetBase.loadRow rows[0] if rows.length>0
			cb(result);

module.exports = CharitybetsBetBase