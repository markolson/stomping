module Stomping::Actions
	class Replier
		attr_accessor :owner
		def initialize(klass, who, &block)
			@owner = klass
			block.call("hi") if block_given?
		end

		def to_s
			"Replier Bot for #{@owner.settings.title}."
		end

		def should_run?(last_run, options = {})
			return true
			return (Time.now - Time.parse(last_run.to_s) >= 60)
		end

		def run
			@owner.new_mentions
		end
	end
end