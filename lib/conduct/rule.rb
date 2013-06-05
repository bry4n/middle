module Conduct
  class Rule

    attr_accessor :action, :subject, :options, :block
    attr_reader :name, :value

    def initialize(action, subject, options = {}, &block)
      @action     = action
      @subject    = subject
      @options    = options
      @block      = block
      @value      = nil
      @name       = "#{action}_#{subject.to_s.downcase}"
    end

    def result(object, opts = {})
      if collection?(object)
        @value = object.to_a.all? {|obj| block_call(obj, opts) }
      else
        @value = block_call(object, opts)
      end
      raise "Result value is not a boolean type" unless boolean_value?
      @value
    end

    def block_call(obj, opts = {})
      opts.any? ? block.call(obj, opts) : block.call(obj)
    end

    def boolean_value?
      value.kind_of?(TrueClass) || value.kind_of?(FalseClass)
    end

    def collection?(obj)
      obj.respond_to?(:to_a)
    end

    def conditions?
      @conditions.present?
    end

  end
end