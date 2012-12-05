source 'https://rubygems.org'

# Specify your gem's dependencies in stomping.gemspec
gemspec

#gem 'parse-cron', :git => 'git://github.com/tomoconnor/parse-cron.git'
gem 'parse-cron', :path => '~/Code/parse-cron/'
p File.join(File.expand_path('~/.stomping/bots/'), '**', "Gemfile")
Dir.glob(File.join(File.expand_path('~/.stomping/bots/'), '*')) do |bot|
	root_bot_path = Pathname.new(bot).realpath.dirname
	gemfile = File.join(root_bot_path, 'Gemfile')
    eval(IO.read(gemfile), binding)
end