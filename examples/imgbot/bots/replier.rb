
require 'google_image_api'
require 'open-uri'
require 'tempfile'

class ImgBot::Replier < Stomping::Bot
	def self.run_action(t)
		names = ([t.user] + t.user_mentions).select { |u|
			u.screen_name.downcase != 'animagereply' #client.user.username makes an API call. twitter dummbbbb
		}.map{ |u| "@#{u.screen_name}" }.join(' ')
		text = t.text
		sliced = 0
		t.user_mentions.each {|u|
			text.slice!(u[:indices][0] - sliced, u[:indices][1] - sliced)
			sliced += u[:indices][1] - u[:indices][0]
		}
		result = GoogleImageApi.find(CGI.unescapeHTML(text.strip) || "ennui", {
			:imgsz => "medium",
			:rsz => 8,
			:start => rand(0..7)*8,
			:as_filetype => "jpg",
			:safe => 'on'
		})
		pic = nil
		while result.images.length > 0 && pic.nil?
			begin
				pic = open(result.images.map {|i| i['url'] }.shift)
				p pic
			rescue
			end
		end
		if pic
			file = Tempfile.new(text)
			file.write(pic.read)
			file.flush
			file.seek(0)
			p t
			client.update_with_media("here ya go #{names}", file, {:in_reply_to_status_id => t[:id_str]})
			file.unlink
		else
			client.update("sorry #{names} - didn't find anything :-\\", {:in_reply_to_status_id => t[:id_str]})
		end
	end

	configure do
		set :description,  "Reply to people and hope for serendipity"
	end
	reply_to :all

end