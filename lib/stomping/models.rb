module Models
	class Client < Sequel::Model
		one_to_many :bots
		one_to_many :requests
	end
	class Bot < Sequel::Model
		many_to_one :client
		one_to_many :tweets
	end
	class Tweet < Sequel::Model
		many_to_one :bot
	end
	class Request < Sequel::Model
		many_to_one :client
	end
end