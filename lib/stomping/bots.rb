module Stomping
  module Bots  
  	attr_accessor :bots

  	def bots
  		@bots ||= []
  		reload! if @bots.empty?
  		@bots
  	end

  	def reload!
  		#Stomping.debug("Reloading bot configs")
  		@bots = []
  		bot_path = File.join(Stomping.bot_path, "*")
		bots = Dir[bot_path].each {|bot|
			bot_config = JSON.load(File.read(bot))
			@bots << Stomping::Bot.new(bot_config)
		}
  	end
  end
end