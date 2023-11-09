require 'rails_helper'

describe "Places" do
    before do
      stubbed_weather_response = {
        "current": {
          "observation_time": "12:14 PM",
          "temperature": 13,
          "weather_code": 113,
          "weather_icons": ["https://assets.weatherstack.com/images/wsymbols01_png_64/wsymbol_0001_sunny.png"],
          "weather_descriptions": ["Sunny"],
          "wind_speed": 0,
          "wind_degree": 349,
          "wind_dir": "N",
          "pressure": 1010,
          "precip": 0,
          "humidity": 90,
          "cloudcover": 0,
          "feelslike": 13,
          "uv_index": 4,
          "visibility": 16
        }
      }.to_json

      stub_request(:get, "http://api.weatherstack.com/current?access_key=#{ENV['WEATHERSTACK_APIKEY']}&query=kumpula")
        .to_return(status: 200, body: stubbed_weather_response, headers: { 'Content-Type' => 'application/json' })
    end
    
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name: "Oljenkorsi", id: 1 ) ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end
  
  it "if multiple are returned by the API, all are shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [
        Place.new(name: "Oljenkorsi", id: 1),
        Place.new(name: "Kumpulan kapakka", id: 2)
      ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
    expect(page).to have_content "Kumpulan kapakka"
  end

  it "if none are returned by the API, a notice is shown on the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return([])

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "No locations in kumpula"
  end
end