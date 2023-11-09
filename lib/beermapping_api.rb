class BeermappingApi
  def self.places_in(city)
    city = city.downcase
    Rails.cache.fetch(city, expires_in: 1.week) do
      get_places_in(city)
    end
  end

  def self.get_places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    bmp_locations = response.parsed_response["bmp_locations"]

    return [] unless bmp_locations

    places = bmp_locations["location"]

    return [] if places.is_a?(Hash) && places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.map do |place|
      Place.new(place)
    end
  end

  def self.key
    return nil if Rails.env.test?

    raise 'BEERMAPPING_APIKEY env variable not defined' if ENV['BEERMAPPING_APIKEY'].nil?

    ENV.fetch('BEERMAPPING_APIKEY')
  end
end
