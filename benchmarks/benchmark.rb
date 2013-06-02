$:.unshift "../lib"

require 'cancan'
require 'pundit'
require 'conduct'
require 'benchmark'

# mock class
class User
  def admin?
    true
  end
end

# cancan
class AbilityCanCan
  include CanCan::Ability

  def initialize(user = User.new)
    can :manage, User do |u|
      user.admin?
    end
  end

end

# pundit
class AbilityPundit
  include Pundit
  def current_user
    @current_user ||= User.new
  end
end

class UserPolicy
  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  def manage?
    @current_user.admin?
  end
end

# conduct
class AbilityConduct < Conduct
  can :manage, User do |u|
    current_user.admin?
  end
end

Benchmark.bm(25) do |b|

  b.report("CanCan") do
    1_000_000.times do
      AbilityCanCan.new(User.new).can?(:manage, User.new)
    end
  end

  b.report("Pundit") do
    1_000_000.times do
      AbilityPundit.new.policy(User.new).manage?
    end
  end

  b.report("Conduct") do
    1_000_000.times do
      AbilityConduct.new(User.new).can?(:manage, User.new)
    end
  end

end