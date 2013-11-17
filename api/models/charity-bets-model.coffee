sys = require "sys"
async = require "async"
CharityBetsBet = require "../../lib/data/message.coffee"
CharityBetsBet = require "../../lib/data/charitybets-bet.coffee"
CharityBetsBets = require "../../lib/data/charitybets-bets.coffee"
PledgeAppsModel = require "./pledge-apps-model.coffee"

class CharityBetsModel
	@appData: (userId, cb) ->
		async.parallel [(callback) =>
			PledgeAppsModel.leaderboards 'charitybets', 0, (data) ->
				callback null, data
		, (callback) =>
			CharityBetsModel.openBets (data) ->
				callback null, data
		, (callback) =>
			CharityBetsModel.myBets userId, (data) ->
				callback null, data
		], (err, results) =>
			cb {
				leaderboards: results[0],
				publicBets: results[1],
				myBets: results[2]
			}
	@openBets: (cb) ->
		CharityBetsBets.loadOpenPublicBets cb
	@myBets: (userId, cb) ->
		CharityBetsBets.loadUsersBets userId, cb
	@postBet: (submitterId, acceptorId, amount, title, eventDate, cb) ->
		CharityBetsBet.post submitterId, acceptorId, amount, title, eventDate, cb
	@acceptBet: (user, betId, cb) ->
		#todo make sure the user can accept this bet
		CharityBetsBet.load betId, (bet) ->
			bet.accept user.id, () ->
				body = user.userName + ' accepted the bet.'
				PledgeAppsModel.postMessage 'charitybets', 'bet', bet.id, user.id, true, body, cb
	@rejectBet: (user, betId, cb) ->
		#todo make sure the user can reject this bet
		CharityBetsBet.load betId, (bet) ->
			bet.reject user.id, () ->
				body = user.userName + ' rejected the bet.'
				PledgeAppsModel.postMessage 'charitybets', 'bet', bet.id, user.id, true, body, cb
	@admitDefeat: (user, betId, cb) ->
		CharityBetsBet.load betId, (bet) ->
			if (user.id == bet.acceptorId || user.id == bet.submitterId)
				bet.admitDefeat user.id, () ->
					body = user.userName + ' has admitted defeat.'
					PledgeAppsModel.postMessage 'charitybets', 'bet', bet.id, user.id, true, body, cb
	@claimVictory: (user, betId, cb) ->
		CharityBetsBet.load betId, (bet) ->
			if (user.id == bet.acceptorId || user.id == bet.submitterId)
				body = user.userName + ' has claimed victory.'
				PledgeAppsModel.postMessage 'charitybets', 'bet', bet.id, user.id, true, body, cb
	@userDetails: (userId, cb) ->
		console.log userId
		async.parallel [(callback) =>
			PledgeAppsModel.publicUserData userId, (data) ->
				callback null, data
		, (callback) =>
			CharityBetsModel.myBets userId, (data) ->
				callback null, data
		], (err, results) =>
			result = results[0][0]
			result.bets = results[1]
			cb result
module.exports = CharityBetsModel