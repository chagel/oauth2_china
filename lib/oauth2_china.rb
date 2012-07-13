require "oauth2_china/version"

module Oauth2China
  class Base
    def config
      CONFIG[self.name] ||= lambda do
        require 'yaml'
        filename = "#{Rails.root}/config/oauth2_china/#{self.name}.yml"
        file     = File.open(filename)
        yaml     = YAML.load(file)
        return yaml[Rails.env]
      end.call
    end

    def initialize(access_token = nil)
      @access_token = access_token
    end
  end

  class Sina < Oauth2China::Base
  end

  class Tencent < Oauth2China::Base
  end

end
