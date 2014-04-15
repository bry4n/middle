Conduct - A lightweight authorization
---

This is work in progress. README will be updated/improved when this is completed.


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

  can :comment, Post, :create_comment?

  can :create, Comment, do |comment|
    false
  end

  def create_comment?(post)
    can? :create, post.comments.new
  end

end

```

**app/controllers/posts_controller.rb**

```ruby
class PostsController < ApplicationController
  before_filter :authorize_ability! only: [:new, :create]

  def index
    if authorize_ability
      @posts = @user.posts
    else
      @posts = @user.posts.public
    end
  end

  def edit
    redirect_to root_url unless can?(:update, @post)
  end

  ...

end
```

**app/views/posts/index.html.erb**

```ruby
<% if can?(:create, @post) %>
  <%= link_to "New Post", new_post_path %>
<% end %>
```
