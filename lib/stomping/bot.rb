module Stomping
  class Bot 
    attr_accessor :name, :description
    extend Stomping::Actions
    include Stomping::Actions

    def initialize(config)
      @name = config['name']
      @description = config['description']
    end
  end
end