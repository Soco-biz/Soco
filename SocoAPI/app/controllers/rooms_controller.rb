class RoomsController < ApplicationController
  before_action :take_location

  """
  @parameter: ?latitude=float&logitude=float
  """
  # ルームを取得する
  # お試し用 -> ?latitude=35.641927&longitude=139.408568
  def index
    @around_room = Room.within(0.2, origin: [@latitude, @longitude])
                      .select(:name)
                      .order(created_at: :desc)
    @state_room = Room.where(state: @state)
                      .select(:name)
                      .order(created_at: :desc)
    @local_room = Room.where(local: @local)
                      .select(:name)
                      .order(created_at: :desc)

    render formats: 'json', status: :ok
  end

  """
  @parameter: ?latitude=float&logitude=float
  content-type: application/x-www-form-urlencoded
  -d room[name]=room_name
  """
  # ルーム作成を行う
  # お試し用 -> ?latitude=35.6552625&longitude=139.4109211, room[name]: 程久保
  def create
    room_info = Room.new(room_params)
    @post_room = create_post_info(room_info)

    # 半径200m以内に同じ名前の部屋があるか
    flag = Room.within(0.2, origin: [@latitude, @longitude])
               .where(name: @post_room[:name])
               .exists?

    if flag # 部屋があったら作らない
      render formats: 'json', status: :not_acceptable
    else # 部屋がなかったら作成許可
      if @post_room.save
        render formats: 'json', status: :created
      else
        render formats: 'json', status: :unprocessable_entity
      end
    end
  end

  private

  # 緯度経度,市町村区,都道府県を取得する
  def take_location
    @latitude = params[:latitude].to_f
    @longitude = params[:longitude].to_f

    param = [@latitude, @longitude]
    location = Geocoder.search(param)

    @state, @local = take_address(location)
  end

  # 受け取ったjsonから市町村区,都道府県の部分のみを抽出する
  def take_address(location)
    begin
      comp = location[0].address_components
      address_comp = comp.map { |adress| adress['long_name'] }[1..-1].reverse
    rescue NoMethodError
      render formats: 'json', status: :not_found
      return
    end

    if address_comp.length <= 2
      state, local = address_comp[0], address_comp[1]
    else
      state, local = address_comp[2], address_comp[3]
    end
  end

  # dbにいれる用のパラメータを作成する
  def create_post_info(room_info)
    room_info[:latitude] = @latitude
    room_info[:longitude] = @longitude
    room_info[:state] = @state
    room_info[:local] = @local

    room_info
  end

  def room_params
    params.require(:room).permit(:name)
  end
end
