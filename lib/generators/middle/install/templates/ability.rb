class Ability

  include Middle

  define_action create: [:new, :create]
  define_action read:   [:index, :show]
  define_action update: [:edit, :update]
  define_action delete: [:destroy]

  define_action manage: [:create, :read, :update, :delete]


  can :manage, :all do
  #  current_user.admin?
    false
  end

  #include ExampleAbility

end
