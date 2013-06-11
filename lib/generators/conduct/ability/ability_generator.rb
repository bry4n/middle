module Conduct
  module Generators
    class AbilityGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      def create_ability
        template 'ability_module.rb', File.join('app/abilities', class_path, "#{file_name}_ability.rb")
      end
    end
  end
end