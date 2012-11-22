include Stomping::Bots

if Stomping.bots.count == 0
	print "No bots have been registered with stomping yet.\n"
	print "stomping add [path]\n"
end
print "Bots:\n"
Stomping.bots.each {|bot|
	printf("%s\t%s\n", bot.name, bot.description)
}

print "\nActions:\n"

Stomping.actions.each{|action|
	p action
}