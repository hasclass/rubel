module Rubel
  module Runtime
    # Sandbox is the default runtime for production environments.
    # It has some basic protection against ruby code injection.
    #
    # Sandbox is a {BasicObject} so it lives outside the default namespace.
    # To access outside classes and modules you are forced to use "::" as
    # namespace.
    # 
    # @example Extending Runtime::Sandbox
    #
    #    class MySandbox < Rubel::Runtime::Sandbox
    #      include ::MyModule::MyClass
    #      
    #      def hello_world
    #        ::Kernel.puts "hello world"
    #      end
    #    
    #      def create_blog_post
    #         ::BlogPost.create(:title => 'hello world')
    #      end
    #    end
    # 
    # @example Protection against ruby injection:
    #
    #   r = Rubel::Runtime::Sandbox.new
    #   r.execute lambda { system('say hello') }              # NoMethodError 'system'
    #   r.execute lambda { Object.new.system('say hello') }   # Constant Object not found
    #
    # @example Protection against ruby injection does not work in this case:
    #   r.execute lambda { ::Object.new.system('say hello') }
    #   # However, passing query as String does basic string sanitizing
    #   r.execute "::Object.new.system('say hello')"
    #   # This can be circumvented:
    #   r.execute "#{(':'+':'+'Object').constantize.new.system('say hello')"
    #
    #   # If you have rubel functions that use instance_eval for objects.
    #   r.execute lambda { MAP([0.1234, 2.12], "round(1) * 3.0; system('say hello);") }
    #  
    class Sandbox < BasicObject
      include ::Rubel::Core

      # BasicObject does not contain {Kernel} methods, so we add the
      # most important manually:

      # make -> {} and lambda {} work when included as BasicObject
      def lambda(&block)
        ::Kernel.lambda(&block)
      end

      def puts(str)
        ::Kernel.puts(str)
      end

      def sanitize!(string)
        string.gsub!('::', '')
      end
    end
  end
end
