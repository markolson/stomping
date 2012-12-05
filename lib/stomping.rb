require "rubygems"
require "bundler/setup"

require 'json'
require 'parse-cron'
require 'oauth'
require 'twitter'
require 'sequel'

require "stomping/actions"
require "stomping/bot"
require "stomping/bots"
require 'stomping/db'
require "stomping/thankyousinatra"
require "stomping/twitter"
require "stomping/version"

module Stomping

	class << self
		attr_accessor :config_path, :bot_path, :db
		attr_accessor :last_rate_reset, :rates
	end

	self.rates = {
		'mentions' => 15,
		'search' => 150
	}

	self.last_rate_reset = nil
	
	self.config_path = File.expand_path('~/.stomping')
	self.db = Stomping::DB.new("#{self.config_path}/bots.db")
	
	self.bot_path = File.join(self.config_path, "bots")
end
