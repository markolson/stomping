module Stomping
	module ThankYouSinatra
    	def settings; self; end

		def configure(*envs, &block)
        	yield self if envs.empty? || envs.include?(environment.to_sym)
      	end

	    def set(option, value = (not_set = true), ignore_setter = false, &block)
			raise ArgumentError if block and !not_set
			value, not_set = block, false if block

			if not_set
			  raise ArgumentError unless option.respond_to?(:each)
			  option.each { |k,v| set(k, v) }
			  return self
			end

			if respond_to?("#{option}=") and not ignore_setter
			  return __send__("#{option}=", value)
			end

			setter = proc { |val| set option, val, true }
			getter = proc { value }

			case value
			when Proc
			  getter = value
			when Symbol, Fixnum, FalseClass, TrueClass, NilClass
			  getter = value.inspect
			when Hash
			  setter = proc do |val|
			    val = value.merge val if Hash === val
			    set option, val, true
			  end
			end

			define_singleton_method("#{option}=", setter) if setter
			define_singleton_method(option, getter) if getter
			define_singleton_method("#{option}?", "!!#{option}") unless method_defined? "#{option}?"
			self
		end

		private
		def define_singleton_method(name, content = Proc.new)
	        # replace with call to singleton_class once we're 1.9 only
	        (class << self; self; end).class_eval do
	          undef_method(name) if method_defined? name
	          String === content ? class_eval("def #{name}() #{content}; end") : define_method(name, &content)
	        end
		end
	end
end