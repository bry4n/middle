$:.unshift "lib"

unless defined?(ActiveSupport)
  require 'active_support/concern'
  require 'active_support/core_ext/class'
  require 'active_support/core_ext/object'
end

require "conduct/rule"
require "conduct/action_controller"

module Conduct
  extend ActiveSupport::Concern

  module ClassMethods

    def current_user
      @@current_user
    end

    def current_user=(user)
      @@current_user = user
    end

    def can(action, subject, *args, &block)
      options = args.extract_options!
      block = args.pop if args.last.kind_of?(Proc)
      rules << Rule.new(action, subject, options, &block)
    end

    def rules
      @@rules ||= []
    end

  end

  def current_user
    @current_user
  end

  def rules
    @rules ||= self.class.rules
  end

  def initialize(user)
    @current_user = self.class.current_user = user
  end

  def can?(action, subject, options = {})
    rule = find_rule_for(action, subject)
    return false unless rule
    rule.call(subject, options)
  end

  def cannot?(*args)
    !can?(*args)
  end

  private

  def find_rule_for(action, subject)
    rules.select do |rule|
      rule.match?(action, subject)
    end.first
  end

end

