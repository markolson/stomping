require "rubygems"
require "bundler/setup"

require 'json'
require 'cron_parser'
require 'oauth'
require 'twitter'

require "stomping/actions"
require "stomping/bot"
require "stomping/bots"
require "stomping/thankyousinatra"
require "stomping/twitter"
require "stomping/version"

module Stomping
	class << self
		attr_accessor :config_path, :bot_path
	end
	
	self.config_path = File.expand_path('~/.stomping')
	self.bot_path = File.join(self.config_path, "bots")
end
