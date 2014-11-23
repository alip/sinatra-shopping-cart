# coding: utf-8
# Copyright (c) 2014 Ali Polatel <alip@exherbo.org>
# Licensed under the terms of the GNU General Public License v3 (or later)

require 'andand'
require 'multi_json'

require 'sinatra/base'
require 'sinatra/activerecord'

require 'swagger/blocks'

require_relative '../models/init'
require_relative 'authentication'

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

  helpers do
    def json(json)
      MultiJson.dump(json, :pretty => true)
    end
  end

  include Swagger::Blocks
  SWAGGERED_CLASSES = [Cart, Product, User, SampleShop].freeze

  swagger_root do
    key :swaggerVersion, '1.2'
    key :apiVersion, '0.1'
    info do
      key :title, 'Sinatra Shopping Cart API Sample'
      key :description, 'This is a sample sinatra shopping cart API. It is just an example and not complete.'
      key :contact, 'alip@exherbo.org'
      key :license, 'GPL-3'
    end
    api do
      key :path, '/products'
      key :description, 'Operations about products'
    end
    api do
      key :path, '/carts'
      key :description, 'Operations about carts'
    end
  end

  # Authentication
  use Warden::Manager do |config|
    config.scope_defaults :default,
                          :strategies => [:password],
                          :action => '/api/unauthenticated'
    config.failure_app = self
    config.intercept_401 = false
  end

  before '/api' do
    content_type :json
  end

  post '/api/unauthenticated' do
    halt 401, json({ :message => 'Sorry, this request can not be authenticated. Try again.' })
  end

  before '/api/carts/*' do
    env['warden'].authenticate!(:password)
    @current_user = env['warden'].user
  end

  get '/' do
    redirect '/index.html' # Swagger
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

  swagger_api_root :carts do
    key :swaggerVersion, '1.2'
    key :apiVersion, '0.1'
    key :basePath, BASE_PATH
    key :resourcePath, '/carts'
    api do
      key :path, '/carts/index'
      operation do
        key :method, 'GET'
        key :summary, 'Cart Index'
        key :notes, 'Lists all available carts'
        key :nickname, :listCarts
        key :type, :array
        items do
          key :'$ref', :Cart
        end
        parameter do
          key :paramType, :header
          key :name, :'USERNAME'
          key :description, 'User name'
          key :required, true
          key :type, :string
        end
        parameter do
          key :paramType, :header
          key :name, :'PASSWORD'
          key :description, 'User password'
          key :required, true
          key :type, :string
        end
        response_message do
          key :code, 401
          key :message, 'Invalid username or password'
        end
      end
    end
  end

  get '/api/carts/index' do
    Cart.for_user(@current_user).to_json
  end

  swagger_api_root :carts do
    api do
      key :path, '/carts'
      operation do
        key :method, 'POST'
        key :summary, 'Create Cart'
        key :notes, 'Create a new cart'
        key :nickname, :createCart
        key :type, :Cart
        parameter do
          key :paramType, :header
          key :name, :'USERNAME'
          key :description, 'User name'
          key :required, true
          key :type, :string
        end
        parameter do
          key :paramType, :header
          key :name, :'PASSWORD'
          key :description, 'User password'
          key :required, true
          key :type, :string
        end
        response_message do
          key :code, 400
          key :message, 'Invalid arguments'
        end
        response_message do
          key :code, 401
          key :message, 'Invalid username or password'
        end
      end
    end
  end

  post '/api/carts' do
    cart = Cart.for_user(@current_user).create
    if cart.errors.any?
      halt 400, json({:message => cart.errors.messages})
    else
      cart.to_json
    end
  end
end
