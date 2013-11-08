UsersBase = require("./base/users-base.coffee")
Global = require("../global.coffee")
sys = require("sys")


class Users extends UsersBase
	getIds: () =>
		result = []
		@forEach (user) =>
			result.push user.id
		result
	@cast: (baseClass) ->
		baseClass.__proto__ = Users::
		return baseClass
	@loadFromQuery: ( query, params, cb ) ->
		UsersBase.loadFromQuery query, params, (data) ->
			cb Users.cast(data)
	@loadGiversLeaderboard: (appName, userId,  cb) ->
		sql='select u.id, u.user_name, sum(t.amount) as total from transactions t inner join users u on u.id = t.donor_id' +
		' where t.app_name=' +  Global.escape(appName) 
		sql += ' and (u.id='  +  userId + ' OR u.id in (select friend_id from friends where user_id='  +  userId + '))' if userId>0
		sql += ' group by u.id, u.user_name order by sum(t.amount) desc limit 100'
		Global.query sql, {}, (err, rows) ->
			cb rows
	@loadWinnersLeaderboard: (appName, userId, cb) ->
		sql='select u.id, u.user_name, sum(t.amount) as total from transactions t inner join users u on u.id = t.benefactor_id' +
		' where t.app_name=' +  Global.escape(appName)
		sql += ' and (u.id='  +  userId + ' OR u.id in (select friend_id from friends where user_id='  +  userId + '))' if userId>0
		sql += ' group by u.id, u.user_name order by sum(t.amount) desc limit 100'
		Global.query sql, {}, (err, rows) ->
			cb rows
module.exports = Users
