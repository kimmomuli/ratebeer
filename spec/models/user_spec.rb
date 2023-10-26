require 'rails_helper'

RSpec.describe User, type: :model do
    describe "favorite brewery" do
    let(:user) { FactoryBot.create(:user) }
    let(:brewery1) { FactoryBot.create(:brewery, name: "Brewery One") }
    let(:brewery2) { FactoryBot.create(:brewery, name: "Brewery Two") }

    it "has method for determining the favorite brewery" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have a favorite brewery" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "returns the brewery of the only rated beer if only one rating" do
      create_beer_and_rating_for_brewery(brewery1, 20)
      expect(user.favorite_brewery).to eq(brewery1)
    end

    it "returns the brewery with the highest average rating if several rated" do
      create_beer_and_rating_for_brewery(brewery1, 10)
      create_beer_and_rating_for_brewery(brewery1, 20)
      create_beer_and_rating_for_brewery(brewery2, 30)
      create_beer_and_rating_for_brewery(brewery2, 40)

      expect(user.favorite_brewery).to eq(brewery2)
    end
  end

  describe "favorite style" do
    let(:user) { FactoryBot.create(:user) }
    let(:brewery) { FactoryBot.create(:brewery) }
    let(:lager_style) { "Lager" }
    let(:ipa_style) { "IPA" }

    it "has method for determining the favorite style" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have a favorite style" do
      expect(user.favorite_style).to eq(nil)
    end

    it "returns the style of the only rated beer if only one rating" do
      create_beer_and_rating(ipa_style, 20)
      expect(user.favorite_style).to eq(ipa_style)
    end

    it "returns the style with the highest average rating if several rated" do
      create_beer_and_rating(ipa_style, 10)
      create_beer_and_rating(ipa_style, 20)
      create_beer_and_rating(lager_style, 30)
      create_beer_and_rating(lager_style, 40)

      expect(user.favorite_style).to eq(lager_style)
    end
  end

  describe "favorite beer" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for determining the favorite beer" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have a favorite beer" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_many_ratings({user: user}, 10, 20, 15, 7, 9)
      best = create_beer_with_rating({ user: user }, 25 )

      expect(user.favorite_beer).to eq(best)
    end
  end
  
  it "has the username set correctly" do
    user = User.new username: "Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username: "Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user) { FactoryBot.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  
  describe "password validation" do
    let(:user) { User.new(username: "TestUser") }

    it "fails with password shorter than 4 characters" do
      user.password = "Ab1"
      user.password_confirmation = "Ab1"

      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end

    it "fails with password containing only lowercase letters" do
      user.password = "abcd"
      user.password_confirmation = "abcd"

      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end

    it "fails without an uppercase letter in password" do
      user.password = "abcd1234"
      user.password_confirmation = "abcd1234"

      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end

    it "fails without a digit in password" do
      user.password = "Abcdefgh"
      user.password_confirmation = "Abcdefgh"

      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end
  end
end

def create_beer_with_rating(object, score)
  beer = FactoryBot.create(:beer)
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
  beer
end

def create_beers_with_many_ratings(object, *scores)
  scores.each do |score|
    create_beer_with_rating(object, score)
  end
end

def create_beer_and_rating(style, score)
  beer = FactoryBot.create(:beer, style: style, brewery: brewery)
  FactoryBot.create(:rating, score: score, beer: beer, user: user)
end

def create_beer_and_rating_for_brewery(brewery, score)
  beer = FactoryBot.create(:beer, brewery: brewery)
  FactoryBot.create(:rating, score: score, beer: beer, user: user)
end