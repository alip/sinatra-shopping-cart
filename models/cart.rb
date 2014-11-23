# coding: utf-8
# Copyright (c) 2014 Ali Polatel <alip@exherbo.org>
# Licensed under the terms of the GNU General Public License v3 (or later)

class Cart < ActiveRecord::Base
  belongs_to :user
  has_many :cart_items

  scope :for_user, -> (u) { where(:user => u) }

  def add_to_cart(product, quantity = 1)
    item = cart_items.find_by(:product => product)

    if item.nil?
      cart_items.create!(:product => product, :quantity => quantity)
    else
      # Important! If we do not validate the new quantity here, we may have
      # dangerous results during the update below.
      # e.g: quantity < 0
      validate_quantity!(quantity)
      item.update!(:quantity => item.quantity + quantity)
    end

    self
  end

  def remove_from_cart(product, quantity = 1)
    item = cart_items.find_by!(:product => product)

    validate_quantity!(quantity)
    new_quantity = item.quantity - quantity

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
    super(options.merge(:include => {:cart_items => {:include => {:product => {:only => [:name, :price]}}}}))
  end

  private

  def validate_quantity!(quantity)
      # TODO: isn't there a simpler way to validate this (new) quantity?
      nci = CartItem.new(:quantity => quantity)
      unless nci.valid?(:quantity) then
        errors.add(:quantity, 'Quantity must be greater than 0')
        raise ActiveRecord::RecordInvalid.new(self)
      end
  end
end
