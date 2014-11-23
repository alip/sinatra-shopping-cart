# coding: utf-8
# Copyright (c) 2014 Ali Polatel <alip@exherbo.org>
# Licensed under the terms of the GNU General Public License v3 (or later)

require 'sinatra/base'
require 'sinatra/activerecord'
require 'swagger/blocks'

require_relative '../models/init'

class SampleShop < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  configure do
    set :app_file, __FILE__
  end

  configure :production do
    BASE_PATH = 'http://188.226.149.34/api'
    set :raise_errors, false
    set :show_exceptions, false
  end

  configure :development, :test do
    BASE_PATH = 'http://localhost:4567/api'
    enable :logging, :dump_errors, :raise_errors
  end

  include Swagger::Blocks
  SWAGGERED_CLASSES = [User, SampleShop].freeze

  swagger_root do
    key :swaggerVersion, '1.2'
    key :apiVersion, '0.1'
    key :basePath, BASE_PATH
    info do
      key :title, 'Sinatra Shopping Cart API Sample'
    end
  end

  get '/' do
    redirect '/index.html' # Swagger
  end

  before '/api' do
    content_type :json
  end

  get '/api/api-docs' do
    Swagger::Blocks.build_root_json(SWAGGERED_CLASSES).to_json
  end

  get '/api/api-docs/:path' do
    Swagger::Blocks.build_api_json(params[:path], SWAGGERED_CLASSES).to_json
  end
end
