module Rubel
  module Runtime
    # Loader determines which runtime to load, based on RAILS_ENV.
    # For production and test environment uses {Rubel::Runtime::Sandbox}. 
    # In all other cases {Rubel::Runtime::Console}
    # 
    # @example 
    #
    #   Rubel::Runtime::Loader.runtime.new  
    #
    # @example For your own Runtime class
    #
    #   class MyRuntime < Rubel::Runtime::Loader.runtime
    #     include ::Rubel::Core
    #   end
    #
    class Loader

      def self.runtime
        case ENV['RAILS_ENV']
        when 'production'  then ::Rubel::Runtime::Sandbox
        when 'test'        then ::Rubel::Runtime::Sandbox
        when 'development' then ::Rubel::Runtime::Console
        else ::Rubel::Runtime::Console
        end
      end

    end
  end
end