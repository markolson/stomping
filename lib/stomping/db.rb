module Stomping
	class DB
		attr_accessor :handle, :clients, :bots, :tweets
		def initialize(path)
			@handle =  Sequel.connect("sqlite://#{path}")
			Sequel::Model.db = @handle
			if !File.exists?(path)
				setup
			end

			require_relative 'models.rb'
			self.class.send(:include, Models)
		end

		def setup
			@handle.create_table(:clients) do
				primary_key :id
				String :name
				String :path
				String :access_key
				String :access_secret
				String :consumer_key
				String :consumer_secret
			end

			@handle.create_table(:bots) do
				primary_key :id
				foreign_key :client_id, :clients
				DateTime 	:last_updated
				String 		:name
			end

			@handle.create_table(:tweets) do
				primary_key	:id
				foreign_key :bot_id, :bots
				DateTime	:tweeted_at
				BigDecimal	:tweeted_id
				BigDecimal	:replied_to
				BigDecimal 	:replied_user
				BigDecimal	:tweet_replied_to
			end
		end
	end
end  