# Seeds
# coding: utf-8
# Copyright (c) 2014 Ali Polatel <alip@exherbo.org>
# Licensed under the terms of the GNU General Public License v3 (or later)

case SampleShop.settings.environment
when :production, :development
  $stderr.puts "Seeding #{SampleShop.settings.environment} database"
  (1..3).each do |i|
    u = User.create!(:name => "User #{i}", :username => "user#{i}", :email => "user#{i}@user#{i}.com",
                     :password => "password#{i}", :password_confirmation => "password#{i}")
    Cart.for_user(u).create!
  end

  (1..10).each do |i|
    p = BigDecimal.new((i + 1) * 10.0, 2)
    Product.create!(:name => "#{i}", :price => p)
  end
end
