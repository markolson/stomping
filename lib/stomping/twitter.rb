module Stomping
	module Twitter
		def twitter_client(auth)
			@client ||= ::Twitter::Client.new(
							:endpoint => 'https://api.twitter.com',
							:consumer_key => auth['CONSUMER_KEY'],
							:consumer_secret => auth['CONSUMER_SECRET'],
							:oauth_token => auth['ACCESS_KEY'],
							:oauth_token_secret => auth['ACCESS_SECRET']
							)
		end
	end
end