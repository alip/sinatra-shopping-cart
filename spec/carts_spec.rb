# coding: utf-8
# Copyright (c) 2014 Ali Polatel <alip@exherbo.org>
# Licensed under the terms of the GNU General Public License v3 (or later)

require_relative 'spec_helper'

describe 'Cart' do
  before :each do
    @user = User.create!(:name => 'test_user', :username => 'test_nick', :email => 'test@test.com',
                         :password => 'test_pass', :password_confirmation => 'test_pass')
    @cart = Cart.for_user(@user).create!
    @products = []
    5.times do |i|
      p = BigDecimal.new((i + 1) * 10.0, 2)
      @products << Product.create!(:name => "#{i}", :price => p)
    end
  end

  describe '.add_to_cart' do
    it 'returns a Cart object' do
      expect(@cart.add_to_cart(@products[0], 1)).to be_a(Cart)
    end

    it 'returns the same Cart object' do
      expect(@cart.add_to_cart(@products[0], 1).id).to eq(@cart.id)
    end

    it 'creates a new CartItem for the Product with default quantity' do
      @cart.add_to_cart(@products[0])
      expect(@cart.cart_items.count).to eq(1)
      expect(@cart.cart_items.first.quantity).to eq(1)
    end

    it 'creates a new CartItem for the Product with the given quantity' do
      @cart.add_to_cart(@products[0], 3)
      expect(@cart.cart_items.count).to eq(1)
      expect(@cart.cart_items.first.quantity).to eq(3)
    end

    it 'refuses to create a CartItem if quantity is zero' do
      expect{@cart.add_to_cart(@products[0], 0)}.to raise_error(ActiveRecord::RecordInvalid)
      expect(@cart.cart_items.count).to eq(0)
    end

    it 'refuses to create a CartItem if quantity is smaller than zero' do
      expect{@cart.add_to_cart(@products[0], -1)}.to raise_error(ActiveRecord::RecordInvalid)
      expect(@cart.cart_items.count).to eq(0)
    end

    it 'refuses to create a CartItem if quantity is not an integer' do
      expect{@cart.add_to_cart(@products[0], 1.2)}.to raise_error(ActiveRecord::RecordInvalid)
      expect(@cart.cart_items.count).to eq(0)
    end

    it 'updates an already existing CartItem for the same Product' do
      @cart.add_to_cart(@products[0], 1)
      @cart.add_to_cart(@products[0], 2)
      expect(@cart.cart_items.count).to eq(1)
      expect(@cart.cart_items.first.quantity).to eq(3)
    end

    it 'validates new 0 quantity of a Product whose CartItem is to be updated' do
      @cart.add_to_cart(@products[0], 1)
      expect{@cart.add_to_cart(@products[0], 0)}.to raise_error(ActiveRecord::RecordInvalid)
      expect(@cart.cart_items.count).to eq(1)
      expect(@cart.cart_items.first.quantity).to eq(1)
    end

    it 'validates new negative quantity of a Product whose CartItem is to be updated' do
      @cart.add_to_cart(@products[0], 1)
      expect{@cart.add_to_cart(@products[0], -3)}.to raise_error(ActiveRecord::RecordInvalid)
      expect(@cart.cart_items.count).to eq(1)
      expect(@cart.cart_items.first.quantity).to eq(1)
    end

    it 'validates new non-integer quantity of a Product whose CartItem is to be updated' do
      @cart.add_to_cart(@products[0], 1)
      expect{@cart.add_to_cart(@products[0], 1.2)}.to raise_error(ActiveRecord::RecordInvalid)
      expect(@cart.cart_items.count).to eq(1)
      expect(@cart.cart_items.first.quantity).to eq(1)
    end
  end

  describe '.remove_from_cart' do
    it 'returns a Cart object' do
      @cart.add_to_cart(@products[0])
      expect(@cart.remove_from_cart(@products[0])).to be_a(Cart)
    end

    it 'returns the same Cart object' do
      @cart.add_to_cart(@products[0])
      expect(@cart.remove_from_cart(@products[0]).id).to eq(@cart.id)
    end

    it 'destroys the CartItem of the Product with default quantity' do
      @cart.add_to_cart(@products[0])
      @cart.remove_from_cart(@products[0])
      expect(@cart.cart_items.count).to eq(0)
    end

    it 'destroys the CartItem of the Product with given quantity' do
      @cart.add_to_cart(@products[0], 2)
      @cart.remove_from_cart(@products[0], 2)
      expect(@cart.cart_items.count).to eq(0)
    end

    it 'decreases the quantity of the CartItem with default quantity' do
      @cart.add_to_cart(@products[0], 2)
      @cart.remove_from_cart(@products[0])
      expect(@cart.cart_items.count).to eq(1)
      expect(@cart.cart_items.first.quantity).to eq(1)
    end

    it 'decreases the quantity of the CartItem with given quantity' do
      @cart.add_to_cart(@products[0], 4)
      @cart.remove_from_cart(@products[0], 2)
      expect(@cart.cart_items.count).to eq(1)
      expect(@cart.cart_items.first.quantity).to eq(2)
    end

    it 'refuses to remove a CartItem if quantity is zero' do
      @cart.add_to_cart(@products[0], 1)
      expect{@cart.remove_from_cart(@products[0], 0)}.to raise_error(ActiveRecord::RecordInvalid)
      expect(@cart.cart_items.count).to eq(1)
      expect(@cart.cart_items.first.quantity).to eq(1)
    end

    it 'refuses to remove a CartItem if quantity is smaller than zero' do
      @cart.add_to_cart(@products[0], 1)
      expect{@cart.remove_from_cart(@products[0], -1)}.to raise_error(ActiveRecord::RecordInvalid)
      expect(@cart.cart_items.count).to eq(1)
      expect(@cart.cart_items.first.quantity).to eq(1)
    end

    it 'refuses to remove a CartItem if quantity is not an integer' do
      @cart.add_to_cart(@products[0], 1)
      expect{@cart.remove_from_cart(@products[0], 1.2)}.to raise_error(ActiveRecord::RecordInvalid)
      expect(@cart.cart_items.count).to eq(1)
      expect(@cart.cart_items.first.quantity).to eq(1)
    end
  end

  describe '.clean' do
    it 'destroys all CartItems of a Cart' do
      @cart.add_to_cart(@products[0], 3)
      @cart.clean
      expect(@cart.cart_items.count).to eq(0)
    end

    it 'returns a Cart object' do
      @cart.add_to_cart(@products[0], 1)
      expect(@cart.clean).to be_a(Cart)
    end

    it 'returns the same Cart object' do
      @cart.add_to_cart(@products[0], 1)
      expect(@cart.clean.id).to eq(@cart.id)
    end
  end

  describe '.set_quantity' do
    it 'returns a Cart object' do
      @cart.add_to_cart(@products[0], 1)
      expect(@cart.set_quantity(@products[0], 3)).to be_a(Cart)
    end

    it 'returns the same Cart object' do
      @cart.add_to_cart(@products[0], 1)
      expect(@cart.set_quantity(@products[0], 3).id).to eq(@cart.id)
    end

    it 'sets the quantity of a CartItem' do
      @cart.add_to_cart(@products[0], 1)
      @cart.set_quantity(@products[0], 3)

      item = @cart.cart_items.find_by(:product => @products[0])
      expect(item).not_to eq(nil)
      expect(item).to be_a(CartItem)
      expect(item.quantity).to eq(3)
    end

    it 'sets the quantity of only one CartItem' do
      @cart.add_to_cart(@products[0])
      @cart.add_to_cart(@products[1])
      @cart.set_quantity(@products[1], 3)

      item0 = @cart.cart_items.find_by(:product => @products[0])
      item1 = @cart.cart_items.find_by(:product => @products[1])

      expect(item0).not_to eq(nil)
      expect(item0).to be_a(CartItem)
      expect(item0.quantity).to eq(1)

      expect(item1).not_to eq(nil)
      expect(item1).to be_a(CartItem)
      expect(item1.quantity).to eq(3)
    end
  end

  describe '.total_price' do
    it 'calculates and returns the total price' do
      @cart.add_to_cart(@products[0], 1)
      expect(@cart.total_price).to be_a(BigDecimal)
      expect(@cart.total_price).to eq(10.0)
    end
  end
end
