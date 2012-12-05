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
		self.class.mentions ||= []
    end

    def run
        p "Starting run - last one was at #{Time.parse(self.class.last_ran.to_s)}" if self.class.last_ran
    	actions.each {|x|
    		if x.should_run?((self.class.last_ran || Time.now), x)
    			x.run
    		end	
    	}
        self.class.ran!
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
	    	request('mentions') do
	    		@mentions = client.mentions_timeline
                update!
	    		m = @mentions.select {|tweet|
	     			last_updated.nil? || DateTime.parse(tweet.created_at.to_s)  > last_updated
	    		}.each {|t|
                    self.run_action(t)
                }
	    	end
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
	          	obj.class.model = Stomping::DB::Bot.where(:client_id => c.id).where(:name => obj.settings.title).first
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
    		p "UPDATING LAST API TIME TO #{Time.now}"
    		model.update(:last_updated => Time.now).save
    	end

        def ran!
            p "UPDATING LAST RUN TIME TO #{Time.now}"
            model.update(:last_ran => Time.now).save
        end

    	def last_updated
    		model.last_updated
    	end

        def last_ran
            model.last_ran
        end

    	def scheduled(&block); @trigger = block; end
    	def mentioned(&block); @trigger = block; end
	end
  end