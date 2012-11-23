module Stomping::Actions
	class Scheduled
		attr_accessor :timer, :owner
		def initialize(klass, timer, &block)
			@timer = timer
			@owner = klass
			block.call("hi") if block_given?
		end

		def to_s
			"Scheduled Bot for #{@owner.settings.title}. Next run at #{@timer.next}"
		end
	end
end