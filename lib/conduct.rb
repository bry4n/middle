$:.unshift "lib"

unless defined?(ActiveSupport)
  require 'active_support/concern'
  require 'active_support/core_ext/array'
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

    def rules
      @@rules ||= {}
    end

    def can(action, subject, *args, &block)
      options = args.extract_options!
      block = args.pop if args.last.kind_of?(Proc)
      define_rule(action, subject, options, &block)
    end

    private

    def define_rule(action, subject, options, &block)
      if action.is_a?(Array)
        action.each do |name|
          rule = Rule.new(name, subject, options, &block)
          if rule_exists?(rule.name)
            raise "Rule action #{action} is already existed. Please use different action name."
          else
            rules[rule.name] = rules
          end
        end
      else
        rule = Rule.new(action, subject, options, &block)
        if rule_exists?(rule.name)
          raise "Rule action #{action} is already existed. Please use different action name."
        else
          rules[rule.name] = rule
        end
      end
    end

    def rule_exists?(name)
      rules[name].present?
    end

  end

  def current_user
    @current_user
  end

  def initialize(user)
    @current_user = self.class.current_user = user
  end

  def rules
    @rules ||= self.class.rules
  end

  def can?(action, subject, options = {})
    name = build_name_for(action, subject)
    rule = rules[name] || rules["#{action}_all"]
    return false unless rule
    rule.result(subject, options)
  end

  def cannot?(*args)
    !can?(*args)
  end

  private

  def build_name_for(action, subject)
    _subject = find_class(subject)
    "#{action}_#{_subject.to_s.downcase}"
  end

  def find_class(subject)
    return subject.model_name if subject.respond_to?(:model_name)
    return subject.class.model_name if subject.class.respond_to?(:model_name)
    return find_class(subject.first) if subject.is_a?(Array)
    subject.is_a?(Class) ? subject : subject.class
  end

end

