path = ARGV[1]

require 'digest/sha1'

begin
	if(path.nil?)
		raise "You must specify a path"
	elsif(!File.exists?(path))
		raise "Path #{path} does not exist.\n"
	elsif(!File.exists?(File.join(path, 'config.json')))
		raise "config.json file does not exist in #{path}"
	end
rescue 
	print $!.to_s + "\n\n"
	print "stomping add [path]\n"
	exit
end

config_path = File.join(path, 'config.json')
config = JSON.load(File.read(config_path))

bot_path = File.join(Stomping.bot_path, config['name'].gsub(/[^0-9a-z]/i, ''))
begin
	File.symlink(config_path, bot_path)
rescue Errno::EEXIST

end
print "Added bot '#{config['name']}'\n"

#oauth register if the config isn't right.