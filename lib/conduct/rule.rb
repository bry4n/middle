module Conduct
  class Rule

    attr_accessor :action, :subject, :options, :block, :result
    attr_reader :name

    def initialize(action, subject, options = {}, &block)
      @action     = action
      @subject    = subject
      @options    = options
      @block      = block
      @collection = options[:collection].presence || false
      @conditions = @collection && @block.present? || false
      @result     = nil
      if collection?
        @name   = "#{action}_#{subject.to_s.downcase}_collection"
      else
        @name   = "#{action}_#{subject.to_s.downcase}"
      end
    end

    def call(obj, opts = {})
      if collection?
        raise "Must use block/proc when collection is used" unless conditions?
        @result = obj.to_a.all? {|o| block_call(o, opts) }
      else
        @result = block_call(obj, opts)
      end
      raise "Result value is not a boolean type" unless boolean_value?
      @result
    end

    def block_call(obj, opts = {})
      opts.any? ? block.call(obj, opts) : block.call(obj)
    end

    def boolean_value?
      result.kind_of?(TrueClass) || result.kind_of?(FalseClass)
    end

    def collection?
      @collection
    end

    def conditions?
      @conditions.present?
    end

  end
end