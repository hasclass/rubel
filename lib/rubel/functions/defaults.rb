module Rubel
  module Functions
    # Default/standard functions like SUM,AVG,COUNT,etc that operate
    # on numbers and are application independent.
    module Defaults
      def MAP(elements, attr_name)
        elements = [elements] unless elements.is_a?(::Array) 
        
        elements.tap(&:flatten!).map! do |a| 
          if attr_name.respond_to?(:call)
             a.instance_exec(&attr_name)
          else
            # to_s imported, for when MAP(..., demand) demand comes through method_missing (as a symbol)
            a.instance_eval(attr_name.to_s)
          end
        end
        elements.length <= 1 ? (elements.first || 0.0) : elements
      end

      # Returns how many values. Removes nil values, but does 
      # not remove duplicates.
      # 
      # @example Basic useage
      #   COUNT(1)              # => 1
      #   COUNT(1,2)            # => 1
      #
      # @example with converters
      #   COUNT(L(foo,bar))     # => 2
      #
      # @example multiple LOOKUPs (does not remove duplicates)
      #   COUNT(L(foo,bar), L(foo))     # => 3
      #   # However: (LOOKUP removes duplicates)
      #   COUNT(L(foo,bar,foo), L(f))   # => 2
      #
      # @example nil values are removed (do not count)
      #   COUNT(1,nil,2) # => 2
      #
      # @param [Numeric,Array] *values one or multiple values or arrays
      # @return [Numeric] The element count.
      #
      def COUNT(*values)
        values.flatten!
        values.compact!

        values.length
      end

      # Returns the average of all number (ignores nil values).
      #
      # @example
      #   AVG(1,2)          # => 1.5
      #   AVG(1,2,3)        # => 2
      #   AVG(1,nil,nil,2)  # => 1.5
      #
      # @param [Numeric,Array] *values one or multiple values or arrays
      # @return [Numeric] The average of all values
      #
      def AVG(*values)
        values.flatten!
        values.compact!
        SUM(values) / COUNT(values)
      end

      # Returns the sum of all numbers (ignores nil values).
      #
      # @example
      #   SUM(1,2)          # => 3
      #   SUM(1,2,3)        # => 6
      #   SUM(1)            # => 1
      #   SUM(1,nil)        # => 1
      #
      # @param [Numeric,Array] *values one or multiple values or arrays
      # @return [Numeric] The average of all values
      #
      def SUM(*values)
        values.flatten!
        values.compact!
        values.inject(0) {|h,v| h + v }
      end
      
      # Multiplies all numbers (ignores nil values).
      #
      # @example
      #   PRODUCT(1,2)     # => 2 (1*2)
      #   PRODUCT(1,2,3)   # => 6 (1*2*3)
      #   PRODUCT(1)       # => 1
      #   PRODUCT(1,nil)   # => 1
      #
      # @param [Numeric,Array] *values one or multiple values or arrays
      # @return [Numeric] The average of all values
      #
      def PRODUCT(*values)    
        values.flatten!
        values.compact!
        values.inject(1) {|total,value| total = total * value}
      end

      
      # Divides the first with the second.
      #
      # @example
      #   DIVIDE(1,2)      # => 0.5
      #   DIVIDE(1,2,3,4)  # => 0.5 # only takes the first two numbers
      #   DIVIDE([1,2])    # => 0.5
      #   DIVIDE([1],[2])  # => 0.5
      #   DIVIDE(1,2)      # => 0.5
      #
      # @example Watch out doing normal arithmetics (outside DIVIDE)
      #   DIVIDE(2,3)      # => 0.66
      #   # (divideing integers gets you elimentary school output. 2 / 3 = 0 with remainder 2)
      #   2 / 3            # => 0
      #   2 % 3            # => 2 # % = modulo (what is the remainder)
      #   2.0 / 3          # => 0.66 If one number is a float it works as expected
      #   2 / 3.0          # => 0.66 If one number is a float it works as expected
      #
      # @example Exceptions
      #   DIVIDE(nil, 1)   # => 0.0
      #   DIVIDE(0.0, 1)   # => 0.0 and not NaN
      #   DIVIDE(0,   1)   # => 0.0 and not NaN
      #   DIVIDE(1.0,0.0)  # => Infinity
      #
      # @param [Numeric,Array] *values one or multiple values or arrays. But only the first two are taken.
      # @return [Numeric] The average of all values
      #
      def DIVIDE(*values)
        a,b = values.tap(&:flatten!)

        if a.nil? || a.to_f == 0.0
          0.0
        else
          a.to_f / b
        end
      end      
    end
  end
end
