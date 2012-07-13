require "oauth2_china/version"
require "faraday"
require "hashie"
require "json"

module Oauth2China
  class Base
  end

  class Sina < Oauth2China::Base
    def initialize(access_token)
      @access_token = access_token

      @tmpl = Hashie::Mash.new({
        access_token: access_token,
      })

      @conn = Faraday.new(:url => 'https://api.weibo.com') do |faraday|
        faraday.request  :multipart
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

    def statuses_update(status, latitude = nil, longitutde = nil, annotation = nil)
      params            = @tmpl.clone
      params.status     = status
      params.lat        = latitude if latitude
      params.long       = longitutde if longitutde
      params.annotation = annotation if annotation

      res = @conn.post("/2/statuses/update.json", params).body
      Hashie::Mash.new(JSON.parse res)
    end

    def statuses_upload(status, picture, latitude = nil, longitutde = nil, annotation = nil)
      params            = @tmpl.clone
      params.pic        = Faraday::UploadIO.new(picture, 'image/jpeg')
      params.status     = status
      params.lat        = latitude if latitude
      params.long       = longitutde if longitutde
      params.annotation = annotation if annotation

      res = @conn.post("/2/statuses/upload.json", params).body
      Hashie::Mash.new(JSON.parse res)
    end
  end

  class Tencent < Oauth2China::Base
    def initialize(access_token, openid)
      @conn = Faraday.new(:url => 'https://open.t.qq.com') do |faraday|
        faraday.request  :multipart
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end

      @tmpl = Hashie::Mash.new({
        oauth_consumer_key: 801183628,
        access_token: access_token,
        openid: openid,
        clientip: '202.102.154.3',
        oauth_version: '2.a',
        format: "json"
      })
    end

    def statuses_update(status, latitude = nil, longitutde = nil, annotation = nil)
      params         = @tmpl.clone
      params.content = status
      params.jing    = latitude if latitude
      params.wei     = longitutde if longitutde

      res = @conn.post("/api/t/add", params.to_hash).body
      Hashie::Mash.new(JSON.parse res)
    end

    def statuses_upload(status, picture, latitude = nil, longitutde = nil, annotation = nil)
      params         = @tmpl.clone
      params.content = status
      params.pic     = Faraday::UploadIO.new(picture, 'image/jpeg')
      params.jing    = latitude if latitude
      params.wei     = longitutde if longitutde

      res = @conn.post("/api/t/add_pic", params.to_hash).body
      Hashie::Mash.new(JSON.parse res)
    end
  end

end
