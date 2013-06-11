Conduct - A lightweight authorization
---

This is work in progress.

### Examples:

**app/abilities/post_ability.rb**

```ruby
module PostAbility

  include Conduct

  can :write, Post do |post|
    current_user.present? && post.new_record?
  end

  can :read, Post do |post|
    post.user == current_user
  end

end

```

**app/abilities/ability.rb**

```ruby
class Ability

  include Conduct

  define_action create: [:new, :create]
  define_action read:   [:index, :show]
  define_action update: [:edit, :update]
  define_action delete: [:destroy]

  define_action manage: [:create, :read, :update, :delete]

  can :manage, :all do
    current_user.present? && current_user.admin?
  end

  include PostAbility

end

```

**app/views/posts/index.html.erb**

```ruby
<% if can?(:create, @post) %>
  <%= link_to "New Post", new_post_path %>
<% end %>
```