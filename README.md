Conduct - A lightweight and fast authorization
---

This is work in progress.

Usage:

```ruby

require 'conduct'

module PostAbility
  
  include Conduct
  
  define_action read: [:index, :show]

  can :write, Post do |post|
    current_user.present? && post.new_record?
  end

  can :write, Post do |post|
    post.user == current_user
  end

end

class Ability
  
  include Conduct
  include PostAbility

  can :manage, :all do
    current_user.present? && current_user.admin?
  end

end

```
