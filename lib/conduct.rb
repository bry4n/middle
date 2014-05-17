$LOAD_PATH.unshift 'lib'

unless defined?(ActiveSupport)
  require 'active_support/concern'
  require 'active_support/core_ext/array'
end

require 'conduct/rule'

module Conduct
  extend ActiveSupport::Concern

  module ClassMethods

    attr_accessor :current_user

    def current_user
      @@current_user
    end

    def current_user=(user)
      @@current_user = user
    end

    def rules
      @@rules ||= {}
    end

    def actions
      @@actions ||= {}
    end

    def define_action(*args)
      options = args.extract_options!
      options.each do |key, value|
        actions[key] = value
      end
    end

    def can(action, subject, *args, &block)
      options = args.extract_options!
      block = args.pop if args.last.kind_of?(Proc)
      if defined_action_exists?(action)
        collection = fetch_action_from_collection(action)
        collection.each { |name| define_rule(name, subject, options, &block) }
      end
      define_rule(action, subject, options, &block)
    end

    private

    def define_rule(action, subject, options, &block)
      if defined_action_exists?(action)
        add_rule_for_defined_action(action, subject, options, &block)
      end
      if action.is_a?(Array)
        action.each do |name|
          rule = Rule.new(name, subject, options, &block)
          add_rule(rule.name, rule)
        end
      else
        rule = Rule.new(action, subject, options, &block)
        add_rule(rule.name, rule)
      end
    end

    def add_rule(name, rule)
      rules[name] = rule unless rule_exists?(rule.name)
    end

    def add_rule_for_defined_action(action, subject, options, &block)
      collection = fetch_action_from_collection(action)
      collection.each do |name|
        rule = Rule.new(name, subject, options, &block)
        add_rule(rule.name, rule)
      end
    end

    def rule_exists?(name)
      rules[name].present?
    end

    def defined_action_exists?(action)
      actions[action].present?
    end

    def fetch_action_from_collection(action)
      list = actions[action]
      fail 'Please define action as collection' unless list.is_a?(Array)
      list
    end

  end

  attr_reader :current_user

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
    subject = find_class(subject)
    "#{action}_#{subject.to_s.downcase}"
  end

  def find_class(subject)
    return subject.model_name if subject.respond_to?(:model_name)
    return subject.class.model_name if subject.class.respond_to?(:model_name)
    return find_class(subject.first) if subject.is_a?(Array)
    subject.is_a?(Class) ? subject : subject.class
  end

end

require 'conduct/rails' if defined?(Rails)
