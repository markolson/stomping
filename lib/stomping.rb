require "rubygems"
require "bundler/setup"

require 'json'
require 'cron_parser'

require "stomping/actions"
require "stomping/bot"
require "stomping/bots"
require "stomping/version"

module Stomping
	class << self
		attr_accessor :config_path, :bot_path
		attr_accessor :actions
	end
	
	self.actions = []
	self.config_path = File.expand_path('~/.stomping')
	self.bot_path = File.join(self.config_path, "bots")
end
