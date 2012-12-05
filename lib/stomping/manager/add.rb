path = ARGV[1]

require 'digest/sha1'
path = File.expand_path(path)
begin
	if(path.nil?)
		raise "You must specify a path"
	elsif(!File.exists?(path))
		raise "Path #{path} does not exist.\n"
	elsif(!File.exists?(File.join(path, 'config.json')))
		raise "config.json file does not exist in #{path}"
	elsif(!File.exists?(File.join(path, 'bot.rb')))
		raise "bot.rb file does not exist in #{path}"
	end
rescue 
	print $!.to_s + "\n\n"
	print "stomping add [path]\n"
	exit
end

config_path = File.join(path, 'config.json')
config = JSON.load(File.read(config_path))

bot_path = File.join(Stomping.bot_path, config['name'].gsub(/[^0-9a-z]/i, ''))
begin
	File.symlink(config_path, bot_path)
rescue Errno::EEXIST
end

saved_bot =  Stomping::DB::Client.find(:path => path)
if not saved_bot
	#accept robot jesus?
	saved_bot = Stomping::DB::Client.create(:name => config[:name], :path => path)
end

oauth_path = File.join(path, 'auth.json')
auth = {}
# what horrible login. the file exists? well ok then!
# but this is just me for a while, so it's ok!
if(!File.exists?(oauth_path))
	puts "************************************"
	puts "You do not have an oauth.json file."
	puts "Go to http://dev.twitter.com and "
	puts "Create a new Application."
	puts "************************************"

	print "Once you have done that, paste in the 'Consumer key' here > "
	auth['CONSUMER_KEY'] =  STDIN.readline.chomp
	print "Paste in the 'Consumer secret' here > "
	auth['CONSUMER_SECRET'] = STDIN.readline.chomp

	oauth = OAuth::Consumer.new(auth['CONSUMER_KEY'], auth['CONSUMER_SECRET'], :site => 'https://api.twitter.com')
	token = oauth.get_request_token

	puts "Now, go to this url and enter the PIN provided. "
	puts token.authorize_url.strip + " > "
	pin = STDIN.readline.chomp

	pinned_token = token.get_access_token(:oauth_verifier => pin.chomp)
	auth['ACCESS_KEY'] = pinned_token.token
	auth['ACCESS_SECRET'] = pinned_token.secret
	File.open(oauth_path, 'w') { |f| f.write(auth.to_json) }
else
	auth = JSON.load(File.read(oauth_path))
	unless auth['ACCESS_KEY']
		oauth = OAuth::Consumer.new(auth['CONSUMER_KEY'], auth['CONSUMER_SECRET'], :site => 'https://api.twitter.com')
		token = oauth.get_request_token

		puts "Now, go to this url and enter the PIN provided. "
		puts token.authorize_url.strip + " > "
		pin = STDIN.readline.chomp

		pinned_token = token.get_access_token(:oauth_verifier => pin.chomp)
		auth['ACCESS_KEY'] = pinned_token.token
		auth['ACCESS_SECRET'] = pinned_token.secret
		File.open(oauth_path, 'w') { |f| f.write(auth.to_json) }
	end
end

saved_bot.access_key = auth['ACCESS_KEY']
saved_bot.access_secret = auth['ACCESS_SECRET']
saved_bot.consumer_key = auth['CONSUMER_KEY']
saved_bot.consumer_secret = auth['CONSUMER_SECRET']
saved_bot.save

Stomping::Bot.from_directory(path, false).each {|x|
	Stomping::DB::Bot.find_or_create(:client_id => saved_bot.id, :name => x.settings.title)
}

puts "Added bot '#{config['name']}'"