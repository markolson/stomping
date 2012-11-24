require_relative "thankyousinatra.rb"
require_relative "twitter"

class Stomping::Bot
    extend Stomping::Actions
    extend Stomping::ThankYouSinatra

    attr_accessor :client

    def initialize(config, auth)
		settings.set(:title, config['name']) unless settings.respond_to? :title
		settings.set(:description, config['description']) unless settings.respond_to? :description
		callback.call("hey") if callback
		self.class.client = auth
    end

    def run
    	actions.each {|x|
    		if x.should_run?(Time.now-1)
    			p "running #{x}"
    			x.run
    		end	
    	}
    end

    def settings; self.class.settings; end
    def actions; self.class.actions; end
    def callback; self.class.trigger; end
    def client; self.class.client; end

    class << self
    	attr_accessor :actions, :trigger, :client, :model
    	attr_accessor :mentions


	    def new_mentions
	    	get_mentions
	    end

	    def get_mentions
	    	p last_updated
	    	p "Getting Mentions"
	    	update!
	    	@mentions = client.mentions_timeline
	     	p @mentions.select {|tweet|
	     		tweet.created_at > (last_updated - (60*60*24*2))
	    	}
	    	p last_updated
	    end

    	def from_directory(root_bot_path, live=false)
    		@bots = []
    		bot_config = JSON.load(File.read(File.join(root_bot_path, "config.json")))
	        require File.join(root_bot_path, "bot.rb")
	        if live
	          auth = twitter_client(JSON.load(File.read(File.join(root_bot_path, 'auth.json'))))
	        end
	        
	        bot_config['runners'].each { |r|
	          unless /\A(?:::)?([A-Z]\w*(?:::[A-Z]\w*)*)\z/ =~ r
	            raise NameError, "#{class_name.inspect} Does not exist in bot '#{bot_config['name']}'"
	          end
	          klass = Object.module_eval("::#{$1}", __FILE__, __LINE__)
	          obj = klass.new(bot_config, auth)
	          if live
	          	c = Stomping::DB::Client.find(:path => root_bot_path.to_s)
	          	obj.class.model = Stomping::DB::Bot.where(:client => c).where(:name => obj.settings.title).first
	          	p obj.class.model
	          end
	          @bots << obj
	        }
	        return @bots
    	end

    	def add_action(action)
    		@actions ||= []
    		@actions << action
    	end

    	def update!
    		model.update(:last_updated => Time.now).save
    	end

    	def last_updated
    		model.last_updated
    	end

    	def scheduled(&block); @trigger = block; end
    	def mentioned(&block); @trigger = block; end
	end
  end