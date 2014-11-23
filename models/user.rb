# coding: utf-8
# Copyright (c) 2014 Ali Polatel <alip@exherbo.org>
# Licensed under the terms of the GNU General Public License v3 (or later)

class User < ActiveRecord::Base
  validates :name, :presence => true
  validates :username, :presence => true, :uniqueness => true
  validates :email, :presence => true, :uniqueness => true

  has_secure_password

  include Swagger::Blocks
  swagger_model :User do
    key :id, :User
    key :required, [:id, :name, :username]
    property :id do
      key :type, :integer
      key :format, :int64
      key :description, 'Unique identifier for User'
    end
    property :name do
      key :type, :string
      key :description, 'User (real) name'
    end
    property :username do
      key :type, :string
      key :description, 'User name'
    end
  end

  def self.authenticate(username, password)
    User.find_by(:username => username).andand.authenticate(password)
  end
end
