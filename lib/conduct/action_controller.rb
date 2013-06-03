module Conduct
  module ActionController
    module Helpers

      def current_ability
        @ability ||= Ability.new(current_user)
      end

      def can?(*args)
        current_ability.can?(*args)
      end

      def cannot?(*args)
        current_ability.cannot?(*args)
      end

    end
  end
end

if defined? ActionController::Base
  ActionController::Base.class_eval do
    include Conduct::ActionController::Helpers
    helper_method :can?, :cannot?, :current_ability
  end
end