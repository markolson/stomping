module Stomping::Actions
	class Scheduled
		attr_accessor :timer, :owner, :options
		def initialize(klass, timer, options, &block)
			@timer = timer
			@owner = klass
			@options = options
			block.call("hi", @options) if block_given?
		end

		def to_s
			"Scheduled Bot for #{@owner.settings.title}. Last at #{@timer.last} Next run at #{@timer.next}. "
		end

		def should_run?(last_ran, options = {})

			last_ran = Time.parse(last_ran.to_s)
			puts "\tLast Run\t\t\tCurrent\t\t[#{@timer.now?}]"
			puts "Last:\t#{@timer.last(last_ran)}\t#{@timer.last}"
			puts "Now: \t#{last_ran}\t#{Time.now}"
			puts "Next:\t#{@timer.next(last_ran)}\t#{@timer.next}"

			#p self
			p @options
			#p (last_ran <= @timer.last)

			false
		end
	end
end