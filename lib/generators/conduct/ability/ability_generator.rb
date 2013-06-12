module Conduct
  module Generators
    class AbilityGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      hook_for :orm

      desc "Create a new ability"

      def create_ability
        template 'ability_module.rb', File.join('app/abilities', class_path, "#{file_name}_ability.rb")
        inject_into_file 'app/abilities/ability.rb', after: "include Conduct\n" do
          "\n  include #{class_name}Activity\n"
        end

      end



    end
  end
end
