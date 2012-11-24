include Stomping::Bots
# https://dev.twitter.com/docs/rate-limiting/1.1
# https://dev.twitter.com/docs/rate-limiting/1.1/limits


Stomping.bots.each {|bot|
	bot.run
}