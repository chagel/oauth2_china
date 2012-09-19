require "oauth2_china/version"
require "faraday"
require "hashie"
require "json"

module Oauth2China
  class Base
  end
  autoload :Sina,    'oauth2_china/strategies/sina'
  autoload :Tencent, 'oauth2_china/strategies/tencent'
end
