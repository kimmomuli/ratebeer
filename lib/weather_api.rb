class WeatherApi
  def self.current_weather(city)
    api_key = ENV.fetch('WEATHERSTACK_APIKEY')
    city = ERB::Util.url_encode(city)

    response = HTTParty.get("http://api.weatherstack.com/current?access_key=#{api_key}&query=#{city}")
    response.parsed_response if response.success?
  end
end
