$:.unshift File.expand_path('../lib', __FILE__)

require 'middle/version'

require "rubygems"

Gem::Specification.new do |gem|
  gem.name            = "middle"
  gem.version         = Middle::VERSION
  gem.author          = "Bryan Goines"
  gem.summary         = "Simple authorization"
  gem.email           = "bryann83@gmail.com"
  gem.homepage        = "https://github.com/bry4n/middle"
  gem.files           = Dir['README.md', 'LICENSE', 'lib/**/*.rb']
  gem.add_dependency "activesupport"
end
