# coding: utf-8
# Copyright (c) 2014 Ali Polatel <alip@exherbo.org>
# Licensed under the terms of the GNU General Public License v3 (or later)

class Cart < ActiveRecord::Base
  belongs_to :user
  has_many :cart_items

  scope :for_user, -> (u) { where(:user => u) }

  def add_to_cart(product, quantity = 1)
    item = cart_items.find_or_create_by!(:product => product) do |new_cart_item|
      new_cart_item = 0
    end

    item.update!(:quantity => item.quantity + quantity)

    self
  end

  def remove_from_cart(product, quantity = 1)
    item = cart_items.find_by!(:product => product)

    new_quantity -= quantity
    if new_quantity <= 0 then
      item.destroy
    else
      item.update!(:quantity => new_quantity)
    end

    self
  end

  def clean
    cart_items.destroy_all
    self
  end

  def set_quantity(product, quantity)
    cart_items.find_by!(:product => product).update!(:quantity => quantity)
    self
  end

  def total_price
    p = 0.0

    cart_items
      .includes(:product).select(:product => :price)
      .map{|ci| ci.total_price}.reduce(0.0, &:+)
  end

  def as_json(options = {})
    super(options.merge(:only => [:id], :methods => [:total_price],
                        :include => {:cart_items => {:only => [:quantity],
                                                     :methods => [:total_price],
                                                     :include => {:product => {:only => [:name, :price]}}}}))
  end
end
