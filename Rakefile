require 'rake/testtask'
require 'sinatra/activerecord/rake'

task :default => :test

namespace :db do
  desc 'Load Sinatra application'
  task :load_config do
    require_relative 'lib/app'
  end

  namespace :test do
    desc 'Reset test database'
    task :reset do
      system 'rake db:drop db:create db:migrate db:setup db:test:prepare RACK_ENV=test'
    end
  end
end

desc 'Run all tests'
task :test => [:'db:test:reset'] do
  Rake::TestTask.new do |t|
    t.pattern = 'spec/*_spec.rb'
  end
end

desc 'Start Unicorn server'
task :serve do
  environment = ENV['env'] || 'development'
  config_file = File.expand_path(File.join(File.dirname(__FILE__), 'config', 'unicorn.rb'))
  sh "unicorn -c '#{config_file}' -E #{environment}"
end
