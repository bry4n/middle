$:.unshift File.expand_path('../lib', __FILE__)

require 'conduct/version'

require "rubygems"

Gem::Specification.new do |gem|
  gem.name            = "conduct"
  gem.version         = Conduct::VERSION
  gem.author          = "Bryan Goines"
  gem.summary         = "Natural Language Date/Time parsing library for Ruby"
  gem.email           = "bryann83@gmail.com"
  gem.homepage        = "https://github.com/bry4n/conduct"
  gem.files           = Dir['README.md', 'LICENSE', 'lib/**/*.rb']
  gem.add_dependency "activesupport", "4.0.0.rc1"
end