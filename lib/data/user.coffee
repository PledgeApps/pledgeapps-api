sys = require("sys")
UserBase = require("./base/user-base.coffee")
Global = require "../global.coffee"

class User extends UserBase
	@cast = (baseClass) ->
		if baseClass != null
			baseClass.__proto__ = User::
		return baseClass
	@loadRow = (row) ->
		 User.cast(UserBase.loadRow row)
	@loadFromQuery = ( query, params, cb ) ->
		UserBase.loadFromQuery query, params, (data) ->
			cb User.cast(data)
	@loadByPrivateKey: (privateKey, cb) ->
		User.loadFromQuery "SELECT * FROM users where private_key=" + Global.escape(privateKey), {}, cb
module.exports = User