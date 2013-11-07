sys = require("sys")
Global = require("../../global.coffee")

class UserBase
	constructor: ( @id, @userName, @registrationSource, @registrationKey, @registrationDate, @privateKey ) ->
		@id = 0 if not @id?
	save: (cb) =>
		columns = { user_name: @userName, registration_source: @registrationSource, registration_key: @registrationKey, registration_date: @registrationDate, private_key: @privateKey }
		if @id == 0
			Global.query "INSERT INTO users SET ?", columns, (err, result) =>
				sys.puts err if err?
				@id=result.insertId
				cb()
		else
			Global.query "UPDATE users SET ? WHERE id = " + @id, columns, cb
	@load = ( id, cb ) ->
		Global.query "SELECT * FROM users where id = " + id, null, (err, rows) =>
			result = UserBase.loadRow rows[0] if (rows.length>0)
			cb(result);
	@delete = ( id, cb ) ->
		Global.query "DELETE FROM users where id = " + id, null, (err, rows) =>
			cb();
	@loadRow = (row) ->
		return new UserBase row.id, row.user_name, row.registration_source, row.registration_key, row.registration_date, row.private_key
	@loadFromQuery = ( query, params, cb ) ->
		Global.query query, params, (err, rows) =>
			sys.puts err if err?
			result = null
			result = UserBase.loadRow rows[0] if rows.length>0
			cb(result);

module.exports = UserBase