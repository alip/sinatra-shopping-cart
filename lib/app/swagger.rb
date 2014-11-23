# coding: utf-8
# Copyright (c) 2014 Ali Polatel <alip@exherbo.org>
# Licensed under the terms of the GNU General Public License v3 (or later)

class SampleShop
  include Swagger::Blocks
  SWAGGERED_CLASSES = [Cart, Product, User, SampleShop].freeze

  get '/api/api-docs' do
    Swagger::Blocks.build_root_json(SWAGGERED_CLASSES).to_json
  end

  get '/api/api-docs/:path' do
    Swagger::Blocks.build_api_json(params[:path], SWAGGERED_CLASSES).to_json
  end

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
    api do
      key :path, '/carts/{cart_id}/add_product'
      operation do
        key :method, 'PUT'
        key :summary, 'Add Product to Cart'
        key :notes, 'Add a product to cart specifying quantity'
        key :nickname, :add_to_cart
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
        parameter do
          key :paramType, :path
          key :name, :cart_id
          key :description, 'Cart ID'
          key :required, true
          key :type, :Cart
        end
        parameter do
          key :paramType, :query
          key :name, :product_id
          key :description, 'Product ID'
          key :required, true
          key :type, :Product
        end
        parameter do
          key :paramType, :query
          key :name, :quantity
          key :description, 'Product quantity'
          key :required, true
          key :type, :integer
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
    api do
      key :path, '/carts/{cart_id}/remove_product'
      operation do
        key :method, 'DELETE'
        key :summary, 'Remove Product from Cart'
        key :notes, 'Remove a product from cart specifying quantity'
        key :nickname, :remove_from_cart
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
        parameter do
          key :paramType, :path
          key :name, :cart_id
          key :description, 'Cart ID'
          key :required, true
          key :type, :Cart
        end
        parameter do
          key :paramType, :query
          key :name, :product_id
          key :description, 'Product ID'
          key :required, true
          key :type, :Product
        end
        parameter do
          key :paramType, :query
          key :name, :quantity
          key :description, 'Product quantity'
          key :required, true
          key :type, :integer
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
end