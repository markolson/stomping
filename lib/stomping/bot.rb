module Stomping
  class Bot 
    attr_accessor :name, :description

    def initialize(config)
      @name = config['name']
      @description = config['description']
    end
  end
end