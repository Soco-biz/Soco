class RoomsController < ApplicationController
  before_action :take_location
  def index
    latitude = params[:latitude]
    longitude = params[:longitude]
    param = [latitude.to_f, longitude.to_f]

    result = Geocoder.search(param)
    render formats: 'json', handlers: 'jbuilder'
  end

  def new
    # create rooms
  end

  private

  def take_location
    # lati, longi is saved
  end
end
