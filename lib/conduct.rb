$:.unshift "lib"

unless defined?(ActiveSupport)
  require 'active_support/core_ext/class'
  require 'active_support/core_ext/object'
end

require "conduct/rule"
require "conduct/action_controller"

class Conduct

  class NoBooleanValue < Exception
    def message
      "Result value is not boolean type."
    end
  end

  class NoCondition < Exception
    def message
      "Must use block/proc while collection is enabled"
    end
  end

  class NoCollection < Exception
    def message
      "The subject is not collection!"
    end
  end

  #cattr_accessor :current_user, :debug

  def self.current_user
    @current_user
  end

  def self.current_user=(user)
    @current_user = user
  end

  def self.can(action, subject, *args, &block)
    options = args.extract_options!
    block = args.pop if args.last.kind_of?(Proc)
    rules << Rule.new(action, subject, options, &block)
  end

  def self.rules
    @rules ||= []
  end

  def initialize(user)
    @current_user = self.class.current_user = user
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

  def current_user
    @current_user
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
