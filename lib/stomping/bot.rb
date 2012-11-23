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

    def settings; self.class.settings; end
    def actions; self.class.actions; end
    def callback; self.class.trigger; end
    def client; self.class.client; end

    class << self
    	attr_accessor :actions, :trigger, :client

    	def add_action(action)
    		@actions ||= []
    		@actions << action
    	end

    	def scheduled(&block); @trigger = block; end
    	def mentioned(&block); @trigger = block; end
	end
  end