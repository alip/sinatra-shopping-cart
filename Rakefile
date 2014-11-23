require 'rake/testtask'
require 'sinatra/activerecord/rake'

task :default => :test

desc 'Run all tests'
task(:test) do
  Rake::TestTask.new do |t|
    t.pattern = 'spec/*_spec.rb'
  end
end

desc 'Start Unicorn server'
task(:serve) do
  environment = ENV['env'] || 'development'
  config_file = File.expand_path(File.join(File.dirname(__FILE__), 'config', 'unicorn.rb'))
  sh "unicorn -c '#{config_file}' -E #{environment}"
end

namespace :db do
  task :load_config do
    require_relative 'lib/app'
  end
end
