module Rubel
  module Core
    # query - The String or Proc to be executed
    def execute(query = nil)

      if query.is_a?(::String)
        query = sanitized_proc(query)
      end
      
      instance_exec(&query)
    #rescue => e
    #  ::Rubel::ErrorReporter.new(e, query)
    end
    alias query execute

    # Sanitize a string from Ruby injection.
    # 
    # It removes "::"  from the string to prevent people to access 
    # classes outside Runtime::Sandbox
    #  
    #
    def sanitize!(string)
      string.gsub!('::', '')
    end

    # Sanitize a string from Ruby injection.
    # 
    # It removes "::"  from the string to prevent people to access 
    # classes outside Runtime::Sandbox
    #  
    #
    def sanitized_proc(string)
      sanitize!(string)
      eval("lambda { #{string} }")
    end

    # Returns method name as a Symbol if args are empty 
    # or a Proc calling method_name with (evaluated) args [1].
    #
    # @example
    #   r$: MAP( [foo, bar], to_s )            
    #   # First it converts foo, bar, to_s to symbols. Then MAP will call :to_s on [:foo, :bar]
    #   # Thus it is equivalent to: [:foo, :bar].map(&:to_s)
    #
    # @example 
    #
    #   r$: MAP( [0.123456, 0.98765],          # the objects
    #   r$:      round( SUM(1,2) )     )       # instruction to round by 3. 
    #   r$: # => Proc.new { round( 3 ) }
    #   
    #
    # @return [Proc]   A Proc with a method call to *name* and arguments *args*. 
    #                  If *args* are Rubel statements, they will be evaluated beforehand. 
    #                  This makes it possible to add objects and rubel statements to method calls.
    #
    # @return [Symbol] The name itself. This is useful for LOOKUPs. E.g. USER( test_123 )
    #     
    def method_missing(name, *args)
      if !(args.nil? || args.length == 0)
        ::Proc.new { self.send(name, *args)  }
      else
        name
      end
    end
  end
end