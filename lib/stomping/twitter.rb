module Twitter
  module API
    module Tweets
      include Twitter::API::Utils

      def limits
        x = request(:get, "/1.1/application/rate_limit_status.json", {})
        x[:body][:resources]
      end
    end
  end
end

module Stomping
	module Twitter
		attr_accessor :client, :next_reset
		def twitter_client(auth)
			@client ||= ::Twitter::Client.new(
							:endpoint => 'https://api.twitter.com',
							:consumer_key => auth['CONSUMER_KEY'],
							:consumer_secret => auth['CONSUMER_SECRET'],
							:oauth_token => auth['ACCESS_KEY'],
							:oauth_token_secret => auth['ACCESS_SECRET']
							)
		end

		def request(type, &block)
			if Stomping.rates.has_key?(type)
				if Stomping.last_rate_reset.nil? || (Stomping.last_rate_reset < DateTime.now - (60*15/86400.0))
					t = @client.limits[:statuses][:'/statuses/mentions_timeline'][:reset].to_s
					reset_at = DateTime.strptime(t, '%s')
					reset_then = reset_at - (60*15/86400.0)
					Stomping.last_rate_reset = reset_then
				end

				similar_api_calls = Stomping::DB::Request.where(:client => self.model.client).where(:type => type).where("requested_at > ?", Stomping.last_rate_reset).count

				# change this from a straight up "over the limit" to a "going faster than the limit allows" thing
				# which will really mostly mean that if you do this more than once a minute, you get an error
				# because twitter does their stuff in 15 minute chunks.
				# also that "15" and "15*60" hardcoded below could be pulled from the @client.limits
				if(similar_api_calls >= 15)
					p "Wait #{15*60 - (Time.now - Time.parse(Stomping.last_rate_reset.to_s)).to_i} Seconds"
					return nil
				end
				p "API: #{similar_api_calls} used"
			end
			begin
				block.call
			rescue
				p $!.rate_limit
				p "Wait #{$!.rate_limit.reset_in} Seconds"
				return nil
			end
			Stomping::DB::Request.create(:client => self.model, :type => type, :requested_at => DateTime.now)

		end
	end
end