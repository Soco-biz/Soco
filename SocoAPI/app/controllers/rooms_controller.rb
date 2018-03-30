class RoomsController < ApplicationController
  before_action :take_location
  def index
    @close_room = Room.within(0.2, origin: [@latitude, @longitude])
                      .select(:name)
                      .order(created_at: :desc)
    @state_room = Room.where(state: @state).select(:name)
                      .order(created_at: :desc)
    @local_room = Room.where(local: @local).select(:name)
                      .order(created_at: :desc)

    render formats: 'json', handlers: 'jbuilder'
  end

  def create
    # create rooms
    # trial -> hodokubo 35.6552625, 139.4109211
    @state
  end

  private

  def take_location
    # lati, longi is saved
    @error = 0 # error valid
    @latitude = params[:latitude].to_f
    @longitude = params[:longitude].to_f

    param = [@latitude, @longitude]
    location = Geocoder.search(param)
    @state, @local = take_address(location)
  end

  def take_address(location)
    begin
      comp = location[0].address_components
      address_comp = comp.map { |adress| adress['long_name'] }[1..-1].reverse
    rescue NoMethodError
      @error = 1
      render formats: 'json', handlers: 'jbuilder'
      return
    end
    state, local = extract_address(address_comp)
  end

  def extract_address(address_comp)
    if address_comp.length <= 2
      state, local = address_comp[0], address_comp[1]
    else
      state, local = address_comp[2], address_comp[3]
    end
  end

  def room_paarams
    params
  end
end
