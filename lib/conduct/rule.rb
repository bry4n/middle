class Conduct
  class Rule

    attr_accessor :action, :subject, :options, :block, :result

    def initialize(action, subject, options = {}, block = nil)
      @action   = action
      @subject  = subject
      @options  = options
      @block    = block
      @result   = nil
    end

    def match?(obj)
      obj.kind_of?(subject) rescue all?
    end


    def all?
      subject.kind_of?(Symbol) && subject == :all ||
      subject.kind_of?(String) && subject == "all"
    end

    def call(obj)
      @result = block.call(obj)
    end

    def boolean_value?
      result.kind_of?(TrueClass) || result.kind_of?(FalseClass)
    end

  end
end