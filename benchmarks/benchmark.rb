$:.unshift "../lib"

require 'cancan'
require 'pundit'
require 'middle'
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

    500.times do |i|
      can :"manage_#{i}", User do |u|
        user.admin?
      end
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

500.times do |i|
  eval <<-EOF
    class User#{i} < User; end
    class User#{i}Policy < UserPolicy; end
  EOF
end

# middle
class AbilityMiddle

  include Middle

  can :manage, User do |u|
    current_user.admin?
  end

  500.times do |i|
    can "manage_#{i}", User do |u|
      current_user.admin?
    end
  end

end

Benchmark.bm(25) do |b|
  range = (1..400).to_a
  b.report("CanCan") do
    100_000.times do
      AbilityCanCan.new(User.new).can?(:manage, User.new)
    end
  end

  b.report("Pundit") do
    100_000.times do |i|
      AbilityPundit.new.policy("User#{range.sample}".constantize.new).manage?
    end
  end

  b.report("Middle") do
    100_000.times do |i|
      AbilityMiddle.new("User#{range.sample}".constantize.new).can?(:manage, User.new)
    end
  end

end
