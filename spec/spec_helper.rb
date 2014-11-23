# coding: utf-8
# Copyright (c) 2014 Ali Polatel <alip@exherbo.org>
# Licensed under the terms of the GNU General Public License v3 (or later)

require 'rspec'
require 'rack/test'
require 'database_cleaner'
require_relative '../lib/app'

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods

  def app
    SampleShop
  end
end

RSpec.configure do |c|
  c.include RSpecMixin

  c.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  c.around(:each) do |t|
    DatabaseCleaner.cleaning do
      t.run
    end
  end
end
