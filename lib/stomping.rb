require "rubygems"
require "bundler/setup"

require 'json'

require "stomping/bot"
require "stomping/bots"
require "stomping/version"

module Stomping
	class << self
		attr_accessor :config_path
		attr_accessor :bot_path
	end
	
	self.config_path = File.expand_path('~/.stomping')
	self.bot_path = File.join(self.config_path, "bots")
end
