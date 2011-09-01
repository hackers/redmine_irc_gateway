module RedmineIRCGateway
  module Command
    extend self

    def register &block
      @@commands = {}
      self.instance_eval &block if block_given?
    end

    def command(instruction, &block)
      if block_given?
        @@commands[instruction.to_sym] = block
      else
        raise SyntaxError 'No block given'
      end
    end

    def exec instruction
      @@commands[instruction.to_sym].call
    rescue => e
      raise NoMethodError
    end

    def method_missing name
      Command.exec(name.to_sym)
    end

  end
end
