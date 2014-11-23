# coding: utf-8
# Copyright (c) 2014 Ali Polatel <alip@exherbo.org>
# Licensed under the terms of the GNU General Public License v3 (or later)

class Product < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  validates :price, :presence => true, :numericality => {:greater_than => 0}

  has_many :cart_items
end
