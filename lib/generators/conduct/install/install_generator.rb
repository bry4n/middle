module Conduct
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      def copy_ability
        template 'abiilty.rb', 'app/abilities/ability.rb'
      end
    end
  end
end