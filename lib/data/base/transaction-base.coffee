sys = require("sys")
Global = require("../../global.coffee")

class TransactionBase
	constructor: ( @id, @donorId, @benefactorId, @appName, @relatedAction, @relatedId, @amount, @transactionDate, @status, @transactionType, @transactionKey ) ->
		@id = 0 if not @id?
	save: (cb) =>
		columns = { donor_id: @donorId, benefactor_id: @benefactorId, app_name: @appName, related_action: @relatedAction, related_id: @relatedId, amount: @amount, transaction_date: @transactionDate, status: @status, transaction_type: @transactionType, transaction_key: @transactionKey }
		if @id == 0
			Global.query "INSERT INTO transactions SET ?", columns, (err, result) =>
				sys.puts err if err?
				@id=result.insertId
				cb()
		else
			Global.query "UPDATE transactions SET ? WHERE id = " + @id, columns, cb
	@load = ( id, cb ) ->
		Global.query "SELECT * FROM transactions where id = " + id, null, (err, rows) =>
			result = TransactionBase.loadRow rows[0] if (rows.length>0)
			cb(result);
	@delete = ( id, cb ) ->
		Global.query "DELETE FROM transactions where id = " + id, null, (err, rows) =>
			cb();
	@loadRow = (row) ->
		return new TransactionBase row.id, row.donor_id, row.benefactor_id, row.app_name, row.related_action, row.related_id, row.amount, row.transaction_date, row.status, row.transaction_type, row.transaction_key
	@loadFromQuery = ( query, params, cb ) ->
		Global.query query, params, (err, rows) =>
			sys.puts err if err?
			result = null
			result = TransactionBase.loadRow rows[0] if rows.length>0
			cb(result);

module.exports = TransactionBase