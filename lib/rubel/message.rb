module Rubel
  # Represents a message call to an object with arguments.
  #
  # Includes some additional data about the call, including the name of the
  # method being called, and the arguments which will be used.
  #
  # Example:
  #   MY_FUNC( something(with, args) )
  #   #        ^^ . . . . . . . . ^^
  #
  class Message
    attr_reader :name, :arguments

    # Creates a new message.
    #
    # @param [Symbol] name
    #   The name of the method which will be called.
    # @param [Array<Object>] arguments
    #   Additional arguments which will be used when calling the method.
    #
    def initialize(name, arguments = [])
      @name      = name
      @arguments = arguments
    end

    # Converts the message to a Proc which should be instance_exec'ed in the
    # target object.
    #
    # @example
    #   message = Message.new(:round, [2])
    #   1.2345.instance_exec(&message)
    #
    def to_proc
      # Use shadows since instance_eval/exec breaks ivars.
      name, arguments = @name, @arguments

      Proc.new { public_send(name, *arguments) }
    end

    # Calls the message on the target object.
    #
    # @param [Object] target
    #   The object to which the message will be sent.
    #
    # @example
    #   message = Message.new(:round, [2])
    #   message.call(1.2345) # => 1.23
    #
    def call(target)
      target.public_send(@name, *@arguments)
    end

    # @return [String]
    #   A human-readable verson of the message for debugging.
    #
    def inspect
      "#<Rubel::Message #{ to_s }>"
    end

    # @return [String]
    #   A nicely formatted version of the message.
    #
    def to_s
      "#{ @name }(#{ @arguments.join(', ') })"
    end
  end # Message
end # Rubel
