require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'spec'
  t.pattern = 'spec/*.spec.rb'
end

task :default => :test
