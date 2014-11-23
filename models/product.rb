# coding: utf-8
# Copyright (c) 2014 Ali Polatel <alip@exherbo.org>
# Licensed under the terms of the GNU General Public License v3 (or later)

class Product < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  validates :price, :presence => true, :numericality => {:greater_than_or_equal_to => 0.01}

  has_many :cart_items

  include Swagger::Blocks
  swagger_model :Product do
    key :id, :Product
    property :id do
      key :type, :integer
      key :format, :int64
      key :required, :true
    end
    property :name do
      key :type, :string
      key :required, :true
    end
    property :price do
      key :type, :string
      key :required, :true
    end
  end
end
