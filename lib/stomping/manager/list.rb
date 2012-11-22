include Stomping::Bots

if Stomping.bots.count == 0
	print "No bots have been registered with stomping yet.\n"
	print "stomping add [path]\n"
end

Stomping.bots.each {|bot|
	printf("%s\t%s\n", bot.name, bot.description)
}
