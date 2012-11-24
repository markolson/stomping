module Models
	class Client < Sequel::Model
		one_to_many :bots
	end
	class Bot < Sequel::Model
		many_to_one :client
		one_to_many :tweets
	end
	class Tweet < Sequel::Model
		many_to_one :bot
	end
end