module Stomping
  module Bots  
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
        bot_config = JSON.load(File.read(f))
        root_bot_path = Pathname.new(f).realpath.dirname
        require File.join(root_bot_path, "bot.rb")
        bot_config['runners'].each { |r|
          unless /\A(?:::)?([A-Z]\w*(?:::[A-Z]\w*)*)\z/ =~ r
            raise NameError, "#{class_name.inspect} Does not exist in bot '#{bot_config['name']}'"
          end
          klass = Object.module_eval("::#{$1}", __FILE__, __LINE__)
          auth = live ? JSON.load(File.read(File.join(root_bot_path, 'auth.json'))) : nil
          @bots << klass.new(bot_config, auth)
        }
		  }
  	end
  end
end