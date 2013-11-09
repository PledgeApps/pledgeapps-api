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
module.exports = Message