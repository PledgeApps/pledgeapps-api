sys = require("sys")
Global = require("../../global.coffee")

class FriendBase
	constructor: ( @id, @userId, @friendId ) ->
		@id = 0 if not @id?
	save: (cb) =>
		columns = { user_id: @userId, friend_id: @friendId }
		if @id == 0
			Global.query "INSERT INTO friends SET ?", columns, (err, result) =>
				sys.puts err if err?
				@id=result.insertId
				cb()
		else
			Global.query "UPDATE friends SET ? WHERE id = " + @id, columns, cb
	@load = ( id, cb ) ->
		Global.query "SELECT * FROM friends where id = " + id, null, (err, rows) =>
			result = FriendBase.loadRow rows[0] if (rows.length>0)
			cb(result);
	@delete = ( id, cb ) ->
		Global.query "DELETE FROM friends where id = " + id, null, (err, rows) =>
			cb();
	@loadRow = (row) ->
		return new FriendBase row.id, row.user_id, row.friend_id
	@loadFromQuery = ( query, params, cb ) ->
		Global.query query, params, (err, rows) =>
			sys.puts err if err?
			result = null
			result = FriendBase.loadRow rows[0] if rows.length>0
			cb(result);

module.exports = FriendBase