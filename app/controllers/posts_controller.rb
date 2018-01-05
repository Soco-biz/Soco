class PostsController < ApplicationController
  def index
    @posts = Post.order(created_at: :desc)
    respond_to do |format|
      format.html{}
      format.json {
        @new_posts = nil
        @new_posts = Post.where('id > ?', params[:id])
      }
    end
  end

  def calculate_range_for_search
    if @room_id == "0" || @room_id == "-1"
      @start_latitude = -1000
      @end_latitude = 1000
      @start_longitude = -1000
      @end_longitude = 1000
    else
      @start_latitude = @room.latitude.to_f - 0.00138889
      @end_latitude = @room.latitude.to_f + 0.00138889
      @start_longitude = @room.longitude.to_f - 0.00138889
      @end_longitude = @room.longitude.to_f + 0.00138889
    end
  end

  def create
    if params[:content].length > 300 then
      redirect_to("/rooms/" + params[:roomId])
    end

    unless params[:content].include?('>>')
      similarity(params[:content])
    end

    @room = Timeline.find_by(id: params[:roomId])
    calculate_range_for_search
    @user_latitude = params[:latitude].to_f
    @user_longitude = params[:longitude].to_f

    if @start_latitude < @user_latitude && @user_latitude < @end_latitude && @start_longitude < @user_longitude && @user_longitude  < @end_longitude || @room_id == "0" || @room_id == Rails.cache.read('lock_room')
      if params[:content].empty? && params[:image].empty?
          redirect_to("/rooms/" + params[:roomId])
      end
        if params[:image].present?
          @image = params[:image]
          imgur()
        end
        post = Post.new(content:params[:content], room:params[:roomId], image:@image_link, similarity: @mostSimId, simvalue: @mostSimvValue, latitude: params[:latitude], longitude: params[:longitude])
        post.save
  end

  def similarity(post)
    @soco = Post.where('room = ?', params[:roomId]).select("id", "content").map{ |p| p.attributes }
    unless @soco.count == 0 || params[:content].length < 2 then
      num = 0
      p @soco.count
      if @soco.count > 20 then
        counts = @soco.count - 20
        @soco = @soco[counts..@soco.count]
        puts @soco
      end
      jsonPosts = {}
      for soco in @soco do
        jsonPosts[soco["id"]] = soco["content"]
        num = num + 1
      end
      uri = URI.parse URI.encode("http://iiojun.xyz:5000/api.soco.com/v1/similarity?comment=#{post}")
      http = Net::HTTP.new(uri.host, uri.port)
      req = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/json'})

      req.body = jsonPosts.to_json
      res = http.request(req)
      result = JSON.parse(res.body).to_hash
      result.to_hash
      p result["comment_id"]
      unless result["comment_id"] == 400 then
        @mostSimvValue = "1"
        @mostSimId = result["comment_id"]
      end
    end
  end

  def delete
    post = Post.find(params[:id]).destroy
    redirect_to("/rooms/0")
  end

  def imgur
    require 'net/http'
    require 'net/https'
    require 'open-uri'
    require 'json'
    require 'base64'
    def web_client
      http = Net::HTTP.new(API_URI.host, API_URI.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http
    end
    @image64 = @image.gsub(/^.+?,/, "")
    params = {:image =>  @image64,
      :gallery => "gallery",
      :name => "name"
    }
    request = Net::HTTP::Post.new(API_URI.request_uri + ENDPOINTS[:image])
    request.set_form_data(params)
    request.add_field('Authorization', API_PUBLIC_KEY)
    response = web_client.request(request)
    @image_link = JSON.parse(response.body)['data']['link']
  end

end

API_URI = URI.parse('https://api.imgur.com')
API_PUBLIC_KEY = 'Client-ID ad65ddb032d22d9'
ENDPOINTS = {
  :image => '3/image',
  :upload => '/3/upload'
}
