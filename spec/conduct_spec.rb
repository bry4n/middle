require File.expand_path("../spec_helper",__FILE__)

describe Conduct do
  let(:user) { User.new }
  let(:ability) { Ability.new(user) }

  #user

  it "user#admin? should be true" do
   user.admin?.should be_true
  end

  # ability
  it "should have current_user object" do
    ability.current_user.should_not be_nil
  end

  it "should be true" do
    ability.can?(:edit, user, {ip: "localhost"}).should be_true
  end

  it "should not create persisted user" do
    ability.can?(:create, user).should be_false
  end

  it "should create new post" do
    ability.can?(:create, Post.new).should be_true
  end

  it "should test new post" do
    ability.can?(:test, Post.new).should be_true
  end


  it "should not create new company" do
    ability.cannot?(:create, Company.new).should be_true
  end

  it "can manage all" do
    ability.can?(:manage, User.new)
  end

  it "can hack anything" do
    post = Post.create
    ability.can?(:hack, post).should be_false
    user_1 = User.new(admin: false)
    user_1.admin = false
    ability = Ability.new(user_1)
    ability.can?(:hack, post).should be_true
  end

  it "should throw error" do
    expect { ability.can?(:bomb, Post.new) }.to raise_error(Exception)
  end

  it "should delete persisted records" do
    posts = ([Post.create] * 5)
    ability.can?(:delete, posts).should be_true
  end

end
