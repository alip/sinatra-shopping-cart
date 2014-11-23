# coding: utf-8
# Copyright (c) 2014 Ali Polatel <alip@exherbo.org>
# Licensed under the terms of the GNU General Public License v3 (or later)

require 'andand'

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

  PROTECTED_ROUTES = ['/api/carts/*']
  AUTH_ERROR_ROUTE = '/api/unauthenticated'
end

require_relative 'app/environment'
require_relative 'app/helpers'
require_relative 'app/auth'
require_relative 'app/swagger'

class SampleShop < Sinatra::Base
  before '/api' do
    content_type :json
  end

  get '/' do
    redirect '/index.html' # Swagger
  end

  get '/api/products/index' do
    Product.all.to_json
  end

  get '/api/carts/index' do
    Cart.for_user(@current_user).to_json
  end

  post '/api/carts' do
    cart = Cart.for_user(@current_user).create
    if cart.errors.any?
      halt 400, json({:message => cart.errors.messages})
    else
      cart.to_json
    end
  end

  put '/api/carts/:id/add_product' do
    c = Cart.for_user(@current_user).find(params[:id])
    p = Product.find(params[:product_id])

    c.add_to_cart(p, params[:quantity])
  end

  delete '/api/carts/:id/remove_product' do
    c = Cart.for_user(@current_user).find(params[:id])
    p = Product.find(params[:product_id])

    c.remove_from_cart(p, params[:quantity])
  end

  delete '/api/carts/:id/clean' do
    c = Cart.for_user(@current_user).find(params[:id])

    c.clean
  end

  patch '/api/carts/:id/product/:product_id/set_quantity' do
    c = Cart.for_user(@current_user).find(params[:id])
    p = Product.find(params[:product_id])

    c.set_quantity(p, params[:quantity])
  end

  get '/api/carts/:id/total_price' do
    c = Cart.for_user(@current_user).find(params[:id])

    c.total_price
  end
end
