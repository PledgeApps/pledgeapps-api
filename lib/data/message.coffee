sys = require("sys")
MessageBase = require("./base/message-base.coffee")
Global = require "../global.coffee"

class Message extends MessageBase
	@cast = (baseClass) ->
		if baseClass != null
			baseClass.__proto__ = Message::
		return baseClass
	@loadRow = (row) ->
		 Message.cast(MessageBase.loadRow row)
	@loadFromQuery = ( query, params, cb ) ->
		MessageBase.loadFromQuery query, params, (data) ->
			cb Message.cast(data)
	@post: (appName, contentType, contentId, senderId, isSystem, body, cb) ->
		Message m = new Message()
		m.appName = appName
		m.body = body
		m.contentId = contentId
		m.contentType = contentType
		m.parentId = 0
		m.senderId = senderId
		m.sentDate = new Date()
		m.isSystem = isSystem
		m.save cb
module.exports = Message