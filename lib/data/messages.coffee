MessagesBase = require("./base/messages-base.coffee")
Global = require("../global.coffee")
sys = require("sys")


class Messages extends MessagesBase
	getIds: () =>
		result = []
		@forEach (user) =>
			result.push user.id
		result
	@cast: (baseClass) ->
		baseClass.__proto__ = Messages::
		baseClass
	@loadFromQuery: ( query, params, cb ) ->
		MessagesBase.loadFromQuery query, params, (data) ->
			cb Messages.cast(data)
	@loadMessageForContent: (appName, contentType, contentId, cb) ->
		sql="SELECT m.*, u.user_name as sender_name
		 FROM messages m
		 LEFT OUTER JOIN Users u on u.id=m.sender_id
		 WHERE app_name = " + Global.escape(appName) + " and 
		 content_type=" + Global.escape(contentType) + " and 
		 content_id=" + Global.escape(contentId)
		Global.query sql, {}, (err, rows) ->
			cb rows
module.exports = Messages
