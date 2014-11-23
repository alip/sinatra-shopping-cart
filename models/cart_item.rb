# coding: utf-8
# Copyright (c) 2014 Ali Polatel <alip@exherbo.org>
# Licensed under the terms of the GNU General Public License v3 (or later)

class CartItem < ActiveRecord::Base
  belongs_to :cart
  belongs_to :product

  validates :quantity, :presence => true,
                       :numericality => {:greater_than => 0}


  scope :for_cart, -> (cart) { where(:cart => cart) }
end
