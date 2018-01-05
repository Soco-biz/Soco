class RoomsController < ApplicationController
# layout 'timeline'

def index
  checkLockedRoomExist()
  #htmlとjsonで処理を分岐。html→処理無し。json→ユーザ周辺の部屋を取得
  respond_to do |format|
    format.html
    format.json {
      #@roomListを初期化
      @roomList = nil
      @userLatitude = params[:latitude]
      @userLongitude = params[:longitude]
      #検索する部屋の範囲を計算する
      calcLocationForSearch()
      #計算後の範囲内のルームを検索して@roomListに代入
      @roomList = Timeline.where(latitude: @startLat..@endLat).where(longitude: @startLng..@endLng)
    }
  end
end

def timeline
  #repond_toで分岐。html→チャットルームの情報を取得 json→自動更新で新たな投稿を取得
  respond_to do |format|
    format.html{
      @roomId = params[:id]
      #ルームIDでルーム情報を抽出
      @room = Timeline.find_by(id: @roomId)

      #例外処理→部屋が一つも存在しない場合
      if @room == nil then
        @room = Timeline.new(id: "0", name: "ラウンジ")
        @room.save
      end

      #ユーザの位置情報を代入して、部屋の検索範囲を計算する
      @userLatitude = @room.latitude
      @userLongitude = @room.longitude
      calcLocationForSearch()

      @posts = Post.order(created_at: :desc).where('room = ?', params[:id])

      #データベース内の投稿のIDと部屋内での投稿番号の紐付け
      manageId()
    }
    format.json {
      #自動更新機能
      #部屋内の最新の投稿のIDより新しいIDの投稿があれば表示
      @new_posts = nil
      @new_posts = Post.where('id > ?', params[:last_id]).where('room = ?', params[:id]).order(id: :asc)
    }
  end
end

def lockRoom
  #修正→現状キャッシュがサーバに保存される
  #例：AさんがXをロックすると、無関係のBさんもXをロックした状態になる
  #jsonで送信されたときのみ対応。一時間のみキャッシュにルームIDを保存
  respond_to do|format|
    format.json {
        Rails.cache.write("lockRoom", params[:lockRoom], expires_in: 1.hours)
        @lockRoom = params[:lockRoom]
    }
  end
end

def create
  #新たに新たにチャットルーム作成
  timeline = Timeline.new(name:params[:room_name], longitude:params[:longitude], latitude:params[:latitude])
  timeline.save
  redirect_to("/rooms")
end

def guide
end

def calcLocationForSearch
  #部屋を検索する範囲を計算する
  #始めのifはラウンジの場合と、ルームIDが"-1"（例外）の場合は無効な値を代入
  if @roomId == "0" || @roomId == "-1"  then
    @startLat = -1000
    @endLat = 1000
    @startLng = -1000
    @endLng = 1000
  else
    #ユーザの位置情報から半径200mを算出。（計算はラフだけど気にしない）
    @startLat = @userLatitude.to_f - 0.00138889
    @endLat = @userLatitude.to_f + 0.00138889
    @startLng = @userLongitude.to_f - 0.00138889
    @endLng = @userLongitude.to_f + 0.00138889
  end
end

def checkLockedRoomExist
  #キャッシュが存在するか確認、存在したら部屋ID、投稿、部屋名を変数に代入
  if Rails.cache.read('lock_room').present? then
    @lockedRoomNum = Rails.cache.read('lock_room')
    @lockedRoomContent = Timeline.find_by(id: @lockedRoomNum)
    @lockedRoomName =  @lockedRoom.name
  else
  #以下の変数はロックした部屋が存在しない場合に代入される
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
