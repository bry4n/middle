module Conduct
  class Rule

    attr_accessor :action, :subject, :options, :block
    attr_reader :name, :value

    def initialize(action, subject, options = {}, &block)
      @action     = action
      @subject    = subject
      @options    = options
      @block      = block
      @collection = options[:collection].presence || false
      @conditions = @collection && @block.present? || false
      @value      = nil
      @name       = "#{action}_#{subject.to_s.downcase}"
      @name       = [@name, "_collection"].join if collection?
    end

    def result(obj, opts = {})
      if collection?
        raise "Must use block/proc when collection is used" unless conditions?
        @value = obj.to_a.all? {|o| block_call(o, opts) }
      else
        @value = block_call(obj, opts)
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

    def collection?
      @collection
    end

    def conditions?
      @conditions.present?
    end

  end
end