module Middle
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      desc "Creates an ability to your application"

      def copy_ability
        template 'ability.rb', 'app/abilities/ability.rb'
      end

    end
  end
end
