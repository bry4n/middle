Middle - simple authorization
---
![image](Middle.png)

[![Build Status](https://travis-ci.org/bry4n/middle.svg?branch=master)](https://travis-ci.org/bry4n/middle)

### Installation

Gemfile

```ruby
gem "middle"
```

Command line interface

```
$ gem install middle
```


**Note** This is work in progress. README will be updated/improved when this is completed.



### Examples:

Define rules in Ability class

```ruby
class Ability

  include Middle

  define_action create: [:new, :create]
  define_action read:   [:index, :show]
  define_action update: [:edit, :update]
  define_action delete: [:destroy]

  define_action manage: [:create, :read, :update, :delete]

  can :manage, :all do
    current_user.present? && current_user.admin?
  end

  can :manage, Post do |post|
    post.member?(current_user)
  end

  can :comment, Post, :create_comment?

  def create_comment?(post)
    can? :create, post.comments.new
  end

end

```

#### Rails


Check for permission if **current_user** is authorized to view user's all posts.

```ruby
class PostsController < ApplicationController

  def index
    if can?(:read, @user.posts)
      @posts = @user.posts
    else
      @posts = @user.posts.public
    end
  end

  ...

end
```

Check for permission in views

```ruby
<% if can?(:create, @post) %>
  <%= link_to "New Post", new_post_path %>
<% end %>
```

### Contributing

If you wish to contribute to this project, please:

* Fork this project on GitHub
* If it involves code, please also write tests for it
* Use named branch
* Send a pull request

### License

Middle is licensed under the MIT license.
