#!/usr/bin/ruby

require 'uri'
require 'net/http'
require 'nokogiri'

require_relative 'HttpUtils.rb'
require_relative 'PasteBin.rb'

# puts PasteBin.format_opt
puts PasteBin.expire_opt
puts PasteBin.visibility_opt

# puts PasteBin.send_file('/home/user/foo.less')
