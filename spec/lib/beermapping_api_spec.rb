require 'rails_helper'
require 'webmock/rspec'

describe "BeermappingApi" do
  describe "in case of cache miss" do

    before :each do
      Rails.cache.clear
    end

    it "When HTTP GET returns one entry, it is parsed and returned" do
      canned_answer = <<-END_OF_STRING
  <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>18856</id><name>Panimoravintola Koulu</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/18856</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18856&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18856&amp;d=1&amp;type=norm</blogmap><street>Eerikinkatu 18</street><city>Turku</city><state></state><zip>20100</zip><country>Finland</country><phone>(02) 274 5757</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
  END_OF_STRING

      stub_request(:get, /.*turku/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

      places = BeermappingApi.places_in("turku")

      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("Panimoravintola Koulu")
      expect(place.street).to eq("Eerikinkatu 18")
    end

  end

  describe "in case of cache hit" do
    before :each do
      Rails.cache.clear
    end

    it "When one entry in cache, it is returned" do
      canned_answer = <<-END_OF_STRING
  <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>18856</id><name>Panimoravintola Koulu</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/18856</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18856&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18856&amp;d=1&amp;type=norm</blogmap><street>Eerikinkatu 18</street><city>Turku</city><state></state><zip>20100</zip><country>Finland</country><phone>(02) 274 5757</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
  END_OF_STRING

      stub_request(:get, /.*turku/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

      BeermappingApi.places_in("turku")
      places = BeermappingApi.places_in("turku")

      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("Panimoravintola Koulu")
      expect(place.street).to eq("Eerikinkatu 18")
    end
  end

  it "When HTTP GET returns no entries, an empty array is returned" do
    stub_request(:get, /.*turku/).to_return(
      body: "<?xml version='1.0' encoding='utf-8' ?><bmp_locations></bmp_locations>",
      headers: { 'Content-Type' => "text/xml" }
    )

    places = BeermappingApi.places_in("turku")
    expect(places).to be_empty
  end

  it "When HTTP GET returns one entry, it is parsed and returned" do
    canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?>
<bmp_locations>
  <location>
    <id>18856</id>
    <name>Panimoravintola Koulu</name>
    <status>Brewpub</status>
    <reviewlink>https://beermapping.com/location/18856</reviewlink>
    <proxylink>http://beermapping.com/maps/proxymaps.php?locid=18856&amp;d=5</proxylink>
    <blogmap>http://beermapping.com/maps/blogproxy.php?locid=18856&amp;d=1&amp;type=norm</blogmap>
    <street>Eerikinkatu 18</street>
    <city>Turku</city>
    <state></state>
    <zip>20100</zip>
    <country>Finland</country>
    <phone>(02) 274 5757</phone>
    <overall>0</overall>
    <imagecount>0</imagecount>
  </location>
</bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*turku/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

    places = BeermappingApi.places_in("turku")

    expect(places.size).to eq(1)
    place = places.first
    expect(place.name).to eq("Panimoravintola Koulu")
    expect(place.street).to eq("Eerikinkatu 18")
  end

  it "When HTTP GET returns many entries, all are returned as Place-objects" do
    canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?>
<bmp_locations>
  <location>
    <id>1</id>
    <name>Panimoravintola Koulu</name>
    <status>Brewpub</status>
    <street>Eerikinkatu 18</street>
    <city>Turku</city>
    <zip>20100</zip>
    <country>Finland</country>
    <phone>(02) 274 5757</phone>
    <overall>75</overall>
  </location>
  <location>
    <id>2</id>
    <name>Uusi Apteekki</name>
    <status>Bar</status>
    <street>Kaskenkatu 1</street>
    <city>Turku</city>
    <zip>20700</zip>
    <country>Finland</country>
    <phone>(02) 469 2424</phone>
    <overall>85</overall>
  </location>
</bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*turku/).to_return(
      body: canned_answer, 
      headers: { 'Content-Type' => "text/xml" }
    )

    places = BeermappingApi.places_in("turku")
    expect(places.size).to eq(2)
    expect(places.first.name).to eq("Panimoravintola Koulu")
    expect(places.first.street).to eq("Eerikinkatu 18")
    expect(places.second.name).to eq("Uusi Apteekki")
    expect(places.second.street).to eq("Kaskenkatu 1")
  end
end
