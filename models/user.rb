# coding: utf-8
# Copyright (c) 2014 Ali Polatel <alip@exherbo.org>
# Licensed under the terms of the GNU General Public License v3 (or later)

class User < ActiveRecord::Base
  validates :name, :presence => true
  validates :username, :presence => true, :uniqueness => true
  validates :email, :presence => true, :uniqueness => true

  has_many :carts
  has_secure_password

  def self.authenticate(username, password)
    User.find_by(:username => username).andand.authenticate(password)
  end
end
