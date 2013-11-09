sys = require "sys"
Config = require "../../config.coffee"
PledgeAppsModel = require "../models/pledge-apps-model.coffee"

class PledgeAppsRoute
	@actionPost: (req, res) ->
		userKey = req.body["k"]
		PledgeAppsModel.userId userKey, (userId) ->
			PledgeAppsRoute.processPost req, res, userId

	@actionGet: (req, res) ->
		userKey = req.query["k"]
		if userKey?
			PledgeAppsModel.userId userKey, (userId) ->
				PledgeAppsRoute.processRequest req, res, userId
		else
			PledgeAppsRoute.processRequest req, res, 0
		
	@processRequest: (req, res, userId) ->
		action = req.query["a"]

		res.setHeader 'Content-Type', 'application/json'
		res.setHeader 'Access-Control-Allow-Origin', '*'

		if action=='contentMessages'
			appName = req.query['appName']
			contentType = req.query['contentType']
			contentId = req.query['contentId']
			PledgeAppsModel.contentMessages appName, contentType, contentId, (data) ->
				res.end JSON.stringify(data)
		else if action=='publicUserData'
			userId = req.query['userId']
			PledgeAppsModel.publicUserData userId, (data) ->
				res.end JSON.stringify(data)

	@processPost: (req, res, userId) ->
		action = req.body["a"]

		res.setHeader 'Content-Type', 'application/json'
		res.setHeader 'Access-Control-Allow-Origin', '*'

		if action=='postMessage'
			appName = req.body['appName']
			contentType = req.body['contentType']
			contentId = req.body['contentId']
			body = req.body['body']
			PledgeAppsModel.postMessage appName, contentType, contentId, userId, body, () ->
				res.end "{}"
		res.end
module.exports = PledgeAppsRoute