# Seeds
# coding: utf-8
# Copyright (c) 2014 Ali Polatel <alip@exherbo.org>
# Licensed under the terms of the GNU General Public License v3 (or later)

case ENV['RACK_ENV']
when /development|test/
  (1..3).each do |i|
    u = User.create(:name => "User #{i}", :username => "user#{i}", :email => "user#{i}@user#{i}.com",
                    :password => "password#{i}", :password_confirmation => "password#{i}")
    #Cart.for_user(u).create
  end

  (1..10).each do |i|
    Product.create(:name => "Product #{i}", :price => i * 10.0)
  end
end
