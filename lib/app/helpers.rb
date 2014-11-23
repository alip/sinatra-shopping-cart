# coding: utf-8
# Copyright (c) 2014 Ali Polatel <alip@exherbo.org>
# Licensed under the terms of the GNU General Public License v3 (or later)

require 'multi_json'

class SampleShop
  helpers do
    def json(json)
      MultiJson.dump(json, :pretty => true)
    end
  end
end
