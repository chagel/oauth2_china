module Oauth2China
  class Sina < Oauth2China::Base
    def initialize(access_token)
      @access_token = access_token

      @tmpl = Hashie::Mash.new({
        access_token: access_token,
      })

      @conn = Faraday.new(:url => 'https://api.weibo.com') do |faraday|
        faraday.request  :multipart
        faraday.request  :url_encoded             # form-encode POST params
        #faraday.response :logger                  # log requests to STDOUT
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

    # since_id         	 false 	 int64 	 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
    # max_id           	 false 	 int64 	 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
    # count            	 false 	 int   	 单页返回的记录条数，默认为50。
    # page             	 false 	 int   	 返回结果的页码，默认为1。
    # filter_by_author 	 false 	 int   	 作者筛选类型，0：全部、1：我关注的人、2：陌生人，默认为0。
    # filter_by_source 	 false 	 int   	 来源筛选类型，0：全部、1：来自微博、2：来自微群，默认为0。
    # filter_by_type   	 false 	 int   	 原创筛选类型，0：全部微博、1：原创的微博，默认为0。
    # trim_user        	 false 	 int   	 返回值中user字段开关，0：返回完整user字段、1：user字段仅返回user_id，默认为0。
    def statuses_mentions(options = {})
      params = @tmpl.clone.merge(options)
      res = @conn.get("/2/statuses/mentions.json", params).body
      Hashie::Mash.new(JSON.parse res)
    end

    # since_id     	 false 	 int64  	 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
    # max_id       	 false 	 int64  	 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
    # count        	 false 	 int    	 单页返回的记录条数，默认为50。
    # page         	 false 	 int    	 返回结果的页码，默认为1。
    # base_app     	 false 	 int    	 是否只获取当前应用的数据。0为否（所有数据），1为是（仅当前应用），默认为0。
    # feature      	 false 	 int    	 过滤类型ID，0：全部、1：原创、2：图片、3：视频、4：音乐，默认为0。
    # trim_user    	 false 	 int    	 返回值中user字段开关，0：返回完整user字段、1：user字段仅返回user_id，默认为0。
    def statuses_friends_timeline(options = {})
      params = @tmpl.clone.merge(options)
      res = @conn.get("/2/statuses/friends_timeline.json", params).body
      Hashie::Mash.new(JSON.parse res)
    end

    # since_id     	 false 	 int64  	 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
    # max_id       	 false 	 int64  	 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
    # count        	 false 	 int    	 单页返回的记录条数，默认为50。
    # page         	 false 	 int    	 返回结果的页码，默认为1。
    # base_app     	 false 	 int    	 是否只获取当前应用的数据。0为否（所有数据），1为是（仅当前应用），默认为0。
    # feature      	 false 	 int    	 过滤类型ID，0：全部、1：原创、2：图片、3：视频、4：音乐，默认为0。
    # trim_user    	 false 	 int    	 返回值中user字段开关，0：返回完整user字段、1：user字段仅返回user_id，默认为0。
    def home_timeline(options = {})
      params = @tmpl.clone.merge(options)
      res = @conn.get("/2/home/timeline.json", params).body
      Hashie::Mash.new(JSON.parse res)
    end

    def place_pois_add_checkin(poiid, status, options = {})
      params = @tmpl.clone.merge(options)

      params.poiid  = poiid
      params.status = status

      res = @conn.post("/2/place/pois/add_checkin.json", params).body
      Hashie::Mash.new(JSON.parse res)
    end

    # 互粉好友ID列表
    def mutual_friends_ids(count=1000,options = {})
      params = @tmpl.clone.merge(options)
      res = @conn.get("/2/friendships/friends/bilateral/ids.json", params).body
      Hashie::Mash.new(JSON.parse res)
    end
  end
end