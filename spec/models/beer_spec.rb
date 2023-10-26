require 'rails_helper'

RSpec.describe Beer, type: :model do
  let(:brewery) { Brewery.create(name: "Test Brewery", year: 2000) }

  describe "when initialized with a name, style, and brewery" do
    let(:beer) { Beer.new(name: "Test Beer", style: "Lager", brewery: brewery) }

    it "is saved to the database" do
      expect(beer.save).to be(true)
      expect(Beer.count).to eq(1)
    end
  end

  describe "when initialized without a name" do
    let(:beer) { Beer.new(style: "Lager", brewery: brewery) }

    it "is not saved to the database" do
      expect(beer.save).to be(false)
      expect(Beer.count).to eq(0)
    end
  end

  describe "when initialized without a style" do
    let(:beer) { Beer.new(name: "Test Beer", brewery: brewery) }

    it "is not saved to the database" do
      expect(beer.save).to be(false)
      expect(Beer.count).to eq(0)
    end
  end
end
