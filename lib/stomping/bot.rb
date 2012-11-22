module Stomping
  class Bot 
    attr_accessor :name, :description

    include Stomping::Actions

    def initialize(config)
      @name = config['name']
      @description = config['description']
      setup if respond_to?(:setup)
    end

  end
end