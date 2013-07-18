module Oauth2China
  class Tencent < Oauth2China::Base
    def initialize(access_token, clientid, openid)
      @conn = Faraday.new(:url => 'https://open.t.qq.com') do |faraday|
        faraday.request  :multipart
        faraday.request  :url_encoded             # form-encode POST params
        #faraday.response :logger                  # log requests to STDOUT
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

    def statuses_mentions(options={})
      params = @tmpl.clone.merge(options)
      res = @conn.get("/api/statuses/mentions_timeline", params.to_hash).body
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

    def friendships_create(name)
      params = @tmpl.clone
      params.name = name
      res = @conn.post("/api/friends/add", params.to_hash).body
      Hashie::Mash.new(JSON.parse res)
    end

    # 互粉好友ID列表
    def mutual_friends_ids(start=1, reqnum=30, options = {})
      params = @tmpl.clone.merge(options)
      params.startindex = start
      params.reqnum = reqnum
      res = @conn.get("/api/friends/mutual_list", params.to_hash).body
      Hashie::Mash.new(JSON.parse res)
    end
  end
end