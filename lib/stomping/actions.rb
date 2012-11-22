require_relative 'actions/scheduled.rb'

module Stomping
	module Actions
		def schedule(options = {}, &block)
			#p "[#{@name}]Scheduler: #{options}"
			if options.is_a?(String)
				Stomping.actions << Scheduled.new(self, CronParser.new(options), &block)
			end

		end

	end
end