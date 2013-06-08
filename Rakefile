require 'rspec/core/rake_task'

task :default => :spec
RSpec::Core::RakeTask.new(:spec)

desc "Generate Benchmark report"
task :benchmark do
  system("cd benchmarks && ruby benchmark.rb")
end

desc "Start IRB session"
task :pry do
  system("pry -r bundler/setup -r ./lib/conduct")
end

namespace :git do
  desc "Push to master"
  task :push do
    system("git push origin master")
  end
end

namespace :gem do
  desc "Build gem"
  task :build => [:clean, :package]

  desc "Package gem"
  task :package do
    system("gem build conduct.gemspec")
    system("mkdir -p pkg")
    system("mv *.gem pkg/")
  end

  desc "Clean up"
  task :clean do
    system("rm -rf pkg/")
  end

  desc "Publish gem to gemfury"
  task :fury do
    system("fury push pkg/*.gem")
  end

end
