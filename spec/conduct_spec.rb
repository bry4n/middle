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
    policy.user.should_not be_nil
  end

  it "should be true" do
    policy.can?(:edit, user).should be_true
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

end
