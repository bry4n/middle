module Conduct
  module ActionController
    module Helpers

      def ability_object(user)
        @ability ||= Ability.new(user)
      end

      def current_ability
        @ability ||= Ability.new(current_user)
      end

      def can?(*args)
        current_ability.can?(*args)
      end

      def cannot?(*args)
        current_ability.cannot?(*args)
      end

      # if authorize_ability
      #   @posts = current_user.posts
      # else
      #   @posts = @user.posts.public
      # end
      def authorize_ability
        return unless defined?(controller_name) || params[:action].present?
        klass = _classify_controller_name
        current_ability.can?(params[:action], klass)
      end

      # before_action :authorize_ability!
      def authorize_ability!
        raise "Access Denied" unless authorize_ability
      end

      private

      def _classify_controller_name
        controller_name.classify.constantize
      end

    end
  end
end

if defined? ActionController::Base
  ActionController::Base.class_eval do
    include Conduct::ActionController::Helpers
    helper_method :can?, :cannot?, :current_ability, :ability_object
  end
end