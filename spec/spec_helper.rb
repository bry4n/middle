$:.unshift "lib"
$:.unshift "spec"

require "middle"
require 'rspec/autorun'
require 'hashie'
require 'mock_class'
require 'pp'

class User < MockClass

  attr_accessor :admin

  def initialize(*args)
    options = args.extract_options!
    @admin = options[:admin] || true
    super(*args)
  end

  def admin?
    self.admin == true
  end

end

class Post < MockClass; end

class Company < MockClass; end

module UserPolicies

  include Middle

  can :test, Post do |post|
    current_user.admin?
  end

end

class Ability


  include Middle

  define_action read: [:index, :show]

  include UserPolicies

  can :hack, :all, ->(klass) do
    !current_user.admin? && klass.persisted?
  end

  can :manage, :all, ->(klass) do
    current_user.admin? && klass.new_record?
  end

  can :edit, User do |u, opts|
    u.id == current_user.id && opts[:ip] == "localhost"
  end

  can :create, Post, ->(klass) do
    current_user.admin? && klass.new_record?
  end

  can :bomb, Post do |post|
    post.id
  end

  can :delete, Post do |post|
    post.persisted?
  end

  can :raise, Post

end
