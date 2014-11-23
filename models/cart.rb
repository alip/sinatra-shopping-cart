# coding: utf-8
# Copyright (c) 2014 Ali Polatel <alip@exherbo.org>
# Licensed under the terms of the GNU General Public License v3 (or later)

class Cart < ActiveRecord::Base
  belongs_to :user
  has_many :cart_items

  scope :for_user, -> (u) { where(:user => u) }

  def add_to_cart(product, quantity = 1)
    item = cart_items.find_or_initialize_by(:product => product) do |new_cart_item|
      new_cart_item = 0
    end

    item.quantity += quantity
    item.save!

    self
  end

  def remove_from_cart(product, quantity = 1)
    item = cart_items.find_by!(:product => product)

    item.quantity -= quantity
    if item.quantity <= 0 then
      item.destroy
    else
      item.save!
    end

    self
  end

  def clean
    cart_items.destroy_all
    self
  end

  def set_quantity(product, quantity)
    if quantity.is_a? Integer then
      cart_items.find_by!(:product => product).update!(:quantity => quantity)
      true
    else
      errors.add_to_base('quantity not a number') unless quantity.is_a? Integer
      false
    end
  end

  def total_price
    p = 0.0

    cart_items
      .includes(:product).select(:product => :price)
      .map{|ci| ci.total_price}.reduce(0.0, &:+)
  end

  include Swagger::Blocks
  swagger_model :Cart do
    key :id, :Cart
    key :required, [:id]
    property :id do
      key :type, :integer
      key :format, :int64
      key :description, 'Unique identifier for Cart'
    end
  end
end
