#coding: utf-8
require 'oauth2_china'

sina = Oauth2China::Sina.new 'SINA_ACCESS_TOKEN'
res = sina.get_uid

puts res
