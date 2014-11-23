# coding: utf-8
# Copyright (c) 2014 Ali Polatel <alip@exherbo.org>
# Licensed under the terms of the GNU General Public License v3 (or later)

require 'warden'

Warden::Manager.before_failure do |env,opts|
  env['REQUEST_METHOD'] = 'POST'
end


Warden::Strategies.add :password  do
  def valid?
    request.env['HTTP_USERNAME'].is_a?(String) && request.env['HTTP_PASSWORD'].is_a?(String)
  end

  def authenticate!
    user = User.authenticate(request.env['HTTP_USERNAME'],
                             request.env['HTTP_PASSWORD'])

    if user.present?
      success!(user)
    else
      fail!('Permission denied.')
    end
  end
end
