module Stomping::Actions
	class Scheduled
		attr_accessor :timer, :owner
		def initialize(klass, timer, &block)
			@timer = timer
			@owner = klass
			block.call("hi")
		end

		def to_s
			"Scheduled Bot for #{@owner.name}. Next run at #{@timer.next}"
		end
	end
end