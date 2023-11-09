class PlacesController < ApplicationController
  def index
  end

  def show
    city = session[:last_searched_city]
    places = Rails.cache.read(city)
    @place = places.find { |p| p.id == params[:id] }

    return unless @place.nil?

    redirect_to places_path, notice: "Place not found."
  end

  def search
    city = params[:city].downcase
    session[:last_searched_city] = city
    @places = BeermappingApi.places_in(city)
    @weather = WeatherApi.current_weather(city) unless @places.empty?

    if @places.empty?
      redirect_to places_path, notice: "No locations in #{city}"
    else
      render :index, status: 418
    end
  end
end
