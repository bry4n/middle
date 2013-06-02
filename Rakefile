require 'rspec/core/rake_task'

task :default => :spec
RSpec::Core::RakeTask.new(:spec)

desc "Generate Benchmark report"
task :benchmark do
  system("cd benchmarks && ruby permission.rb")
end

desc "Start IRB session"
task :pry do
  system("pry -r bundler/setup -r ./lib/conduct")
end
