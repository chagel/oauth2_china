#coding: utf-8
require 'oauth2_china'

#sina = Oauth2China::Sina.new "2.00PvDQzBee3piCd9690cd4fcq5DwtB"
##res = sina.statuses_update("ello wd")
##p res
#res = sina.statuses_upload("come on gif", "./016.gif")
#p res

qq = Oauth2China::Tencent.new "88f6c1b65ff3dbd0ebdda3db123f791a", "7547D743583717EA820A834BE4B50255"
#qq = Oauth2China::Tencent.new "a92e335ad63b4d7dbf9ac9d299fe7817", "565f61c64aa43838af462b355022c562"
res = qq.statuses_update "hello world"
p res
