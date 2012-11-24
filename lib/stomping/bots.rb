module Stomping
  module Bots  
    include Stomping::Twitter
    require 'pathname'
  	attr_accessor :bots

  	def bots(live=true)
  		@bots ||= []
  		reload!(live) if @bots.empty?
  		@bots
  	end

  	def reload!(live=true)
  		#Stomping.debug("Reloading bot configs")
  		@bots = []
  		bot_path = File.join(Stomping.bot_path, "*")

		  Dir[bot_path].each {|f|
        root_bot_path = Pathname.new(f).realpath.dirname
        @bots += Stomping::Bot.from_directory(root_bot_path, live)
		  }
  	end
  end
end