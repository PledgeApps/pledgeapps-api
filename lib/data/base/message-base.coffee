sys = require("sys")
Global = require("../../global.coffee")

class MessageBase
	constructor: ( @id, @parentId, @senderId, @appName, @sentDate, @contentType, @contentId, @body, @isSystem ) ->
		@id = 0 if not @id?
	save: (cb) =>
		columns = { parent_id: @parentId, sender_id: @senderId, app_name: @appName, sent_date: @sentDate, content_type: @contentType, content_id: @contentId, body: @body, isSystem: @isSystem }
		if @id == 0
			Global.query "INSERT INTO messages SET ?", columns, (err, result) =>
				sys.puts err if err?
				@id=result.insertId
				cb()
		else
			Global.query "UPDATE messages SET ? WHERE id = " + @id, columns, cb
	@load = ( id, cb ) ->
		Global.query "SELECT * FROM messages where id = " + id, null, (err, rows) =>
			result = MessageBase.loadRow rows[0] if (rows.length>0)
			cb(result);
	@delete = ( id, cb ) ->
		Global.query "DELETE FROM messages where id = " + id, null, (err, rows) =>
			cb();
	@loadRow = (row) ->
		return new MessageBase row.id, row.parent_id, row.sender_id, row.app_name, row.sent_date, row.content_type, row.content_id, row.body, row.isSystem
	@loadFromQuery = ( query, params, cb ) ->
		Global.query query, params, (err, rows) =>
			sys.puts err if err?
			result = null
			result = MessageBase.loadRow rows[0] if rows.length>0
			cb(result);

module.exports = MessageBase