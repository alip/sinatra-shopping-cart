# coding: utf-8
# Copyright (c) 2014 Ali Polatel <alip@exherbo.org>
# Licensed under the terms of the GNU General Public License v3 (or later)

require 'sinatra/base'
require 'sinatra/activerecord'

require_relative '../models/init'

class SampleShop < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  set :app_file, __FILE__

  get '/' do
    redirect '/index.html' # Swagger
  end
end
