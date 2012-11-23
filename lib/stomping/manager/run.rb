include Stomping::Bots
# https://dev.twitter.com/docs/rate-limiting/1.1
# https://dev.twitter.com/docs/rate-limiting/1.1/limits
module Twitter
  module API
    module Tweets
      include Twitter::API::Utils

      def limits
        x = request(:get, "/1.1/application/rate_limit_status.json", {})
        x[:body][:resources][:statuses]
      end
    end
  end
end

Stomping.bots.each {|bot|
	p bot.client.limits
	exit
	begin
		p bot.client.mentions
	rescue 
		p $!.rate_limit.reset_in
	end
}