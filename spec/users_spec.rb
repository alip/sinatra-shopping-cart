# coding: utf-8
# Copyright (c) 2014 Ali Polatel <alip@exherbo.org>
# Licensed under the terms of the GNU General Public License v3 (or later)

require_relative 'spec_helper'

describe 'User' do
  describe '.create' do
    it 'persists a user with valid attributes' do
      user = User.create(:name => 'my_name', :username => 'my_username', :email => 'my@email.com',
                         :password => 'my_password', :password_confirmation => 'my_password')
      expect(user).to be_persisted
    end
  end
end