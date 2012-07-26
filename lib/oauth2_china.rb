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

    def friendships_create(uid)
      params = @tmpl.clone

      if uid.is_a? String
        params.uid = uid
      else
        params.screen_name = uid
      end

      res = @conn.post("/2/friendships/create.json", params).body
      Hashie::Mash.new(JSON.parse res)
    end

    def users_show(uid)
      params     = @tmpl.clone
      params.uid = uid
      res = @conn.get("/2/users/show.json", params).body
      Hashie::Mash.new(JSON.parse res)
    end

    def get_uid
      params = @tmpl.clone
      res = @conn.get("/2/account/get_uid.json", params).body
      Hashie::Mash.new(JSON.parse res)
    end

    def comments_create(id, comment, comment_ori = 0)
      params             = @tmpl.clone

      params.id          = id
      params.comment     = comment
      params.comment_ori = comment_ori

      res = @conn.post("/2/comments/create.json", params).body
      Hashie::Mash.new(JSON.parse res)
    end
  end

  class Tencent < Oauth2China::Base
    def initialize(access_token, clientid, openid)
      @conn = Faraday.new(:url => 'https://open.t.qq.com') do |faraday|
        faraday.request  :multipart
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end

      @tmpl = Hashie::Mash.new({
        oauth_consumer_key: clientid,
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

    def users_show(name)
      params      = @tmpl.clone
      params.name = name

      res = @conn.post("/api/user/other_info", params.to_hash).body
      Hashie::Mash.new(JSON.parse res)
    end

    def get_uid
      params = @tmpl.clone
      res = @conn.post("/api/user/info", params.to_hash).body
      Hashie::Mash.new(JSON.parse res)
    end
  end

end
