p $LOAD_PATH
require 'bundler/setup'
p bundler_lib = File.expand_path("../..", __FILE__)
p $LOAD_PATH

module ImgBot
	@version = "1.0"
end

require_relative 'bots/replier.rb'