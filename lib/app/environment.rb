# coding: utf-8
# Copyright (c) 2014 Ali Polatel <alip@exherbo.org>
# Licensed under the terms of the GNU General Public License v3 (or later)

class SampleShop
  configure :production do
    BASE_PATH = 'http://188.226.149.34/api'
    set :raise_errors, false
    set :show_exceptions, false
  end

  configure :development, :test do
    BASE_PATH = 'http://localhost:4567/api'
    enable :logging, :dump_errors, :raise_errors
  end
end
