require_relative 'actions/scheduled.rb'
require_relative 'actions/replier.rb'

module Stomping
	module Actions
		def schedule(options = {})
			if options.is_a?(String)
				add_action Scheduled.new(self, CronParser.new(options))
			end
		end

		def reply_to(who)
			add_action  Replier.new(self, who)
		end

	end
end