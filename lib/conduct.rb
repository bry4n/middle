$:.unshift "lib"

require 'active_support/core_ext/class/attribute_accessors'
require 'active_support/core_ext/object/blank'
require "conduct/rule"

class Conduct

  class NoBooleanValue < Exception;
    def message
      "Result value is not boolean type."
    end
  end

  cattr_accessor :user, :debug

  def self.can(action, subject, *args, &block)
    options = args.extract_options!
    block = args.pop if args.last.kind_of?(Proc)
    rules << Rule.new(action, subject, options, &block)
  end

  def self.rules
    @rules ||= []
  end

  def initialize(user)
    @user = self.class.user = user
  end

  def can?(action, subject, options = {})
    rule = find_relevant_rule_for(action, subject)
    unless rule
      puts " ** No rule match for #{action} and #{subject.inspect}" if debug?
      return false
    end
    rule.call(subject, options)
  end

  def cannot?(*args)
    !can?(*args)
  end

  def rules
    @rules ||= self.class.rules
  end

  def user
    @user
  end

  private

  def find_relevant_rule_for(action, subject)
    rules.select do |rule|
      rule.action == action && rule.match?(subject)
    end.first
  end

  def debug?
    self.class.debug
  end

end
