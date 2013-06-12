module <%= class_name %>Ability

  include Conduct

  can :manage, <%= class_name %> do |<%= class_name.downcase %>|
    false
  end

end