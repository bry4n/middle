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
      rule = Rule.new(action, subject, options, &block)
      define_method "_conduct_#{rule.name}", -> { rule }
    end

  end

  def current_user
    @current_user
  end

  def initialize(user)
    @current_user = self.class.current_user = user
  end

  def can?(action, subject, options = {})
    method = find_method_for(action, subject)
#    return false unless method
    unless method
      puts "#{method_name(action, subject)}: false"
      return false
    end
    rule = send(method_name(action, subject))
    rule.call(subject, options)
  end

  def cannot?(*args)
    !can?(*args)
  end

  private

  def find_method_for(action, subject)
    case true
    when respond_to?(method_name(action, subject)) then method_name(action, subject)
    when respond_to?("_conduct_#{action}_all") then "_conduct_#{action}_all"
    else false
    end
  end

  def method_name(action, subject)
    original_subject = original_class_name(subject)
    if subject.respond_to?(:to_a)
      "_conduct_#{action}_#{original_subject.to_s.downcase}_collection"
    else
      "_conduct_#{action}_#{original_subject.to_s.downcase}"
    end
  end

  def original_class_name(subject)
    unless subject.respond_to?(:ancestors)
      subject.class.ancestors.first
    else
      subject.ancestors.first
    end
  end

end

