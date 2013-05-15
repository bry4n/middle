$:.unshift "lib"
$:.unshift "spec"

require "conduct"
require 'rspec/autorun'
require 'hashie'
require 'mock_class'
require 'pp'




class User < MockClass

  property :admin, default: true

  def admin?
    self.admin == true
  end

end

class Post < MockClass
end

class Company < MockClass
end


class Policy < Conduct

  can :hack, :all, -> (klass) do
    !user.admin? && klass.persisted?
  end

  can :manage, :all, -> (klass) do
    user.admin? && klass.new_record?
  end

  can :edit, User do |u, opts|
    u.id == user.id && opts[:ip] == "localhost"
  end

  can :create, Post, -> (klass) do
    user.admin? && klass.new_record?
  end

  can :bomb, Post do |post|
    post.id
  end

  can :delete, Post, collection: true

end
