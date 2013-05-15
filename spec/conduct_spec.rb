require File.expand_path("../spec_helper",__FILE__)

describe Conduct do
  let(:user) { User.new }
  let(:policy) { Policy.new(user) }

  #user

  it "user#admin? should be true" do
   user.admin?.should be_true
  end

  # policy
  it "should have current_user object" do
    policy.current_user.should_not be_nil
  end

  it "should be true" do
    policy.can?(:edit, user, {ip: "localhost"}).should be_true
  end

  it "should not create persisted user" do
    policy.can?(:create, user).should be_false
  end

  it "should create new post" do
    policy.can?(:create, Post.new).should be_true
  end

  it "should not create new company" do
    policy.cannot?(:create, Company.new).should be_true
  end

  it "can hack anything" do
    post = Post.create
    policy.can?(:hack, post).should be_false
    policy = Policy.new(User.new(admin: false))
    policy.can?(:hack, post).should be_true
  end

  it "should throw error" do
    expect { policy.can?(:bomb, Post.new) }.to raise_error(Conduct::NoBooleanValue)
  end

  it "should delete persisted records" do
    posts = ([Post.create] * 5)
    policy.can?(:delete, posts).should be_true
  end

  it "should raise if collection is enabled and condition is empty" do
    posts = ([Post.create] * 5)
    expect { policy.can?(:raise, posts) }.to raise_error(Conduct::NoCondition)
  end

  it "should raise if collection is disabled and condition is enabled" do
    expect { policy.can?(:delete, Class.new) }.to raise_error(Conduct::NoCollection)
  end

end
