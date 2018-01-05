class RoomsController < ApplicationController
# layout 'timeline'

def index
  checkLockedRoomExist()
  respond_to do |format|
    format.html
    format.json {
      @roomList = nil
      @userLatitude = params[:latitude]
      @userLongitude = params[:longitude]
      calcLocationForSearch()
      @roomList = Timeline.where(latitude: @startLat..@endLat).where(longitude: @startLng..@endLng)
    }
  end
end

def timeline
  respond_to do |format|
    format.html{
      @roomId = params[:id]
      @room = Timeline.find_by(id: @roomId)
      if @room == nil then
        @room = Timeline.new(id: "0", name: "ラウンジ")
        @room.save
      end
      @userLatitude = @room.latitude
      @userLongitude = @room.longitude
      calcLocationForSearch()
      @posts = Post.order(created_at: :desc).where('room = ?', params[:id])
      manageId()
    }
    format.json {
      @new_posts = nil
      @new_posts = Post.where('id > ?', params[:last_id]).where('room = ?', params[:id]).order(id: :asc)
    }
  end
end

def lockRoom
  respond_to do|format|
    format.json {
        Rails.cache.write("lockRoom", params[:lockRoom], expires_in: 1.hours)
        @lockRoom = params[:lockRoom]
    }
  end
end

def create
  timeline = Timeline.new(name:params[:room_name], longitude:params[:longitude], latitude:params[:latitude])
  timeline.save
  redirect_to("/rooms")
end

def guide
end

def calcLocationForSearch
  if @roomId == "0" || @roomId == "-1"  then
    @startLat = -1000
    @endLat = 1000
    @startLng = -1000
    @endLng = 1000
  else
    @startLat = @userLatitude.to_f - 0.00138889
    @endLat = @userLatitude.to_f + 0.00138889
    @startLng = @userLongitude.to_f - 0.00138889
    @endLng = @userLongitude.to_f + 0.00138889
  end
end

def checkLockedRoomExist
  if Rails.cache.read('lock_room').present? then
    @lockedRoomNum = Rails.cache.read('lock_room')
    @lockedRoomContent = Timeline.find_by(id: @lockedRoomNum)
    @lockedRoomName =  @lockedRoom.name
  else
    @lockedRoomContent = nil
    @lockedRoomName = 0
    @lockedRoomNum = 0
  end
end

def manageId
  @postId = {}
  @postNum = @posts.count
  @posts.each do |post|
    @postId[post.id] = @postNum
    @postNum = @postNum - 1
  end
end
end
