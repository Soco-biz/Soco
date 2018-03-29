class RoomsController < ApplicationController
  before_action :take_location
  def index
    param = [@latitude, @longitude]
    location = Geocoder.search(param)
    begin
      comp = location[0].address_components
      address_comp = comp.map { |adress| adress['long_name'] }[1..-1].reverse
    rescue NoMethodError
      @error = 1
    end
    if address_comp.length <= 2
      state = address_comp[0]
      local = address_comp[1]
    else
      state = address_comp[2]
      local = address_comp[3]
    end
    @close_room = Room.within(0.2, origin: [param[0], param[1]])
                      .select(:name)
                      .order(created_at: :desc)
    @state_room = Room.where(state: state)
                      .select(:name)
                      .order(created_at: :desc)
    @local_room = Room.where(local: local)
                      .select(:name)
                      .order(created_at: :desc)

    render formats: 'json', handlers: 'jbuilder'
  end

  def new
    # create rooms
    # trial -> hodokubo 35.6552625, 139.4109211
  end

  private

  def take_location
    # lati, longi is saved
    @error = 0 # error valid
    @latitude = params[:latitude].to_f
    @longitude = params[:longitude].to_f
  end
end
