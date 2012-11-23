include Stomping::Bots

if Stomping.bots.count == 0
	puts "No bots have been registered with stomping yet."
	puts "stomping add [path]"
end

Stomping.bots(false).each {|bot|
	printf("%s: %s\n", bot.settings.title, bot.settings.description)
	bot.actions.each {|action|
		puts "\t#{action}"
	}
	puts ""
}