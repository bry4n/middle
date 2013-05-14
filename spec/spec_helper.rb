$:.unshift "lib"

require "conduct"
require 'rspec/autorun'
require 'toystore'
require 'pp'


class User

  include Toy::Store

  attribute :admin, Boolean, default: true

end

class Post
  include Toy::Store
end

class Company
  include Toy::Store
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
