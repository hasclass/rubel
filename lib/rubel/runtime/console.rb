module Rubel
  module Runtime
    # Used for GQL console
    class Console # < BasicObject
      include ::Rubel::Core
      
      # A Pry prompt that logs what user enters to a log file
      # so it can easily be copy pasted by users.
      #
      # DOES NOT WORK :( couldn't make it work 
      # class LoggingPrompt
      #   include Readline
      #
      #   def readline(prompt = "GQL: ", add_hist = true)
      #     @logger ||= Logger.new('gqlconsole/prompt.log', 'daily')
      #     super(prompt, add_hist).tap do |line| 
      #       @logger.info(line)
      #     end
      #   end
      # end

      # Prints string directly
      RESULT_PRINTER = proc do |output, value|
        if value.is_a?(String)
          output.puts value
        else
          ::Pry::DEFAULT_PRINT.call(output, value)
        end
      end

      # Starts the Pry console
      def console
        require 'pry'
        puts "** Console Loaded"
        ::Pry.start(self, 
                  # input: LoggingPrompt.new, 
                  prompt: proc { |_, nest_level| "GQL: " },
                  print:  RESULT_PRINTER)
      end
    end
  end
end