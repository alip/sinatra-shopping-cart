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
    set :root, File.expand_path(File.join(File.dirname(__FILE__), '..'))
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
  SWAGGERED_CLASSES = [Product, User, SampleShop].freeze

  swagger_root do
    key :swaggerVersion, '1.2'
    key :apiVersion, '0.1'
    info do
      key :title, 'Sinatra Shopping Cart API Sample'
      key :description, 'This is a sample sinatra shopping cart API. It is just an example and not complete.'
      key :contact, 'polatel@gmail.com'
      key :license, 'GPL-3'
    end
    api do
      key :path, '/products'
      key :description, 'Operations about products'
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

  swagger_api_root :products do
    key :swaggerVersion, '1.2'
    key :apiVersion, '0.1'
    key :basePath, BASE_PATH
    key :resourcePath, '/products'
    api do
      key :path, '/products/index'
      operation do
        key :method, 'GET'
        key :summary, 'Product Index'
        key :notes, 'Lists all available products'
        key :nickname, :listProducts
        key :type, :array
        items do
          key :'$ref', :Product
        end
      end
    end
  end

  get '/api/products/index' do
    Product.all.to_json
  end
end
