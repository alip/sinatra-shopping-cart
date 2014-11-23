# coding: utf-8
# Copyright (c) 2014 Ali Polatel <alip@exherbo.org>
# Licensed under the terms of the GNU General Public License v3 (or later)

class SampleShop
  # Authentication
  use Warden::Manager do |config|
    config.scope_defaults :default,
                          :strategies => [:password],
                          :action => AUTH_ERROR_ROUTE
    config.failure_app = self
    config.intercept_401 = false
  end

  def warden_handler
    env['warden']
  end

  def current_user
    warden_handler.user
  end

  PROTECTED_ROUTES.each do |route|
    before route do
      env['warden'].authenticate!(:password)
      @current_user = env['warden'].user
    end
  end

  post AUTH_ERROR_ROUTE do
    halt 401, json({ :message => 'Sorry, this request can not be authenticated. Try again.' })
  end
end
