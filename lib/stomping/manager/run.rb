include Stomping::Bots
# https://dev.twitter.com/docs/rate-limiting/1.1
# https://dev.twitter.com/docs/rate-limiting/1.1/limits

p "Starting.."
while true do
	Stomping.bots.each {|bot|
		p "Running #{bot}"
		bot.run
	}
	sleep(60)
end
