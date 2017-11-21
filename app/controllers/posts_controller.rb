API_URI = URI.parse('https://api.imgur.com')
API_PUBLIC_KEY = 'Client-ID ad65ddb032d22d9'
ENDPOINTS = {
  :image => '3/image',
  :upload => '/3/upload'
}
class PostsController < ApplicationController
  def index
now = 0#Time.new - 1800
@posts = Post.order(created_at: :desc)#.where('created_at > ?', now)
respond_to do |format| 
  format.html
  format.json { 
    @new_posts = nil
    @new_posts = Post.where('id > ?', params[:id])
  } 
end
end

def new 
  if params[:room_id].present? then
    @room_id = params[:room_id]
    @room = Timeline.find_by(id: @room_id)
    @startLat = @room.latitude.to_f - 0.00138889
    @endLat = @room.latitude.to_f + 0.00138889
    @startLng = @room.longitude.to_f - 0.00138889
    @endLng = @room.longitude.to_f + 0.00138889
    if @room_id == "0"; then
      p "ラウンジへようこそ"
      @startLat = -1000
      @endLat = 1000
      @startLng = -1000
      @endLng = 1000
    end
  else
    @room_id = 0
    @startLat = -1000
    @endLat = 1000
    @startLng = -1000
    @endLng = 1000
  end
end

def create
  if params[:content].length > 300 then
    redirect_to("/rooms/" + params[:room_id])
  end
  @room_id = params[:room_id]
  @room = Timeline.find_by(id: @room_id)
  @startLat = @room.latitude.to_f - 0.00138889
  @endLat = @room.latitude.to_f + 0.00138889
  @startLng = @room.longitude.to_f - 0.00138889
  @endLng = @room.longitude.to_f + 0.00138889
  @userLat = params[:latitude].to_f
  @userLng = params[:longitude].to_f
  if @startLat < @userLat && @userLat < @endLat && @startLng < @userLng && @userLng  < @endLng || @room_id == "0" then
    unless params[:content].empty? && params[:image].empty? then
      if params[:image].present? then
        @image = params[:image]
        imgur()
      end
      post = Post.new(content:params[:content], room:params[:room_id], image:@image_link, similarity: @mostSimId, simvalue: @mostSimvValue)
      post.save
    end
  end
redirect_to("/rooms/" + params[:room_id])
end
def similarity(post)
  @soco = Post.where('room = ?', params[:room_id]).select("id", "content").map{ |p| p.attributes }
  unless @soco.count == 0 || params[:content].length < 2 then
    num = 0
    jsonPosts = {}
    for soco in @soco do
      jsonPosts[soco["id"]] = soco["content"]
      num = num + 1
    end

    uri = URI.parse URI.encode("http://localhost:5000/api.soco.com/v1/similarity?comment=#{post}")
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
# def trip10(tripkey)
#     salt = (tripkey + "H.").slice(1, 2)
#     salt = salt.gsub(/[^\.-z]/, ".")
#     salt = salt.tr(":;<=>?@[\\]^_`", "ABCDEFGabcdef");
#     trip = tripkey.crypt(salt).slice(-8, 8);
#     return trip
# end

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