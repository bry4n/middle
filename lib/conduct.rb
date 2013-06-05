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
      rule = Rule.new(action, subject, options, &block)
      rules[rule.name] = rule
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
    if subject.respond_to?(:to_a)
      "#{action}_#{_subject.to_s.downcase}_collection"
    else
      "#{action}_#{_subject.to_s.downcase}"
    end
  end

  def find_class(subject)
    return find_class(subject.first) if subject.is_a?(Array)
    if subject.is_a?(Class)
      subject
    else
      subject.class
    end
  end

end

