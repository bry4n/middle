require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rubygems/package_task'
require 'rspec/core/rake_task'
require 'rake/clean'

gem_spec = Gem::Specification.load("middle.gemspec")

Gem::PackageTask.new(gem_spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end

task :default => [:spec]
RSpec::Core::RakeTask.new(:spec)

desc "Generate Benchmark report"
task :benchmark do
  system("cd benchmarks && ruby benchmark.rb")
end

desc "Start IRB session"
task :pry do
  system("pry -r bundler/setup -r ./lib/middle")
end

desc "Rubocop"
task :rubocop do
  system("rubocop lib/middle.rb lib/middle/*.rb")
end
