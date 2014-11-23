task :serve do
  environment = ENV['env'] || 'development'
  config_file = File.expand_path(File.join(File.dirname(__FILE__), 'config', 'unicorn.rb'))
  sh "unicorn -c '#{config_file}' -E #{environment}"
end
