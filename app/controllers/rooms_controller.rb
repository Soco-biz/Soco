class RoomsController < ApplicationController
# layout 'timeline'
def index
  respond_to do |format| 
    format.html
    format.json { 
      @tl = nil
      @roomlist = nil
      @startLat = params[:latitude].to_f - 0.00138889
      @endLat = params[:latitude].to_f + 0.00138889
      @startLng = params[:longitude].to_f - 0.00138889
      @endLng = params[:longitude].to_f + 0.00138889
      @roomlist = Timeline.where(latitude: @startLat..@endLat).where(longitude: @startLng..@endLng)
    } 
  end
end
def timeline
  respond_to do |format| 
    format.html{
      @room = Timeline.find_by(id: params[:id])
      if @room == nil then 
        @room = Timeline.new(id: "0", name: "ラウンジ")
        @room.save
      end
      @room_id = params[:id]
      if @room_id == "0" || @room_id == "-1"  then
        @startLat = -1000
        @endLat = 1000
        @startLng = -1000
        @endLng = 1000
      else
        p @startLat = @room.latitude.to_f - 0.00138889
        p @endLat = @room.latitude.to_f + 0.00138889
        p @startLng = @room.longitude.to_f - 0.00138889
        p @endLng = @room.longitude.to_f + 0.00138889
      end
      now = Time.new
      @posts = Post.order(created_at: :desc).where('room = ?', params[:id]).where('created_at < ?', now)
      manageId()
    }
    format.json { 
      Rails.cache.write('city', params[:last_id], expires_in: 1.minutes)

      @new_posts = nil
      @new_posts = Post.where('id > ?', params[:last_id]).where('room = ?', params[:id]).order(id: :asc)
    } 
  end
end
def new
  roomId = params[:room_id]
end
def create
  thread = Timeline.new(name:params[:room_name], longitude:params[:longitude], latitude:params[:latitude])
  thread.save
  redirect_to("/rooms")
end
def guide
end
def manageId
  @postId = {}
  @postNum = @posts.count
  @posts.each do |post|
    @postId[post.id] = @postNum
    @postNum = @postNum - 1
  end
  p @postId
end
end
