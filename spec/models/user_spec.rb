require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:brewery1) { FactoryBot.create(:brewery, name: "Brewery One") }
  let(:brewery2) { FactoryBot.create(:brewery, name: "Brewery Two") }
  let(:lager) { FactoryBot.create(:style, name: "Lager") }
  let(:ipa) { FactoryBot.create(:style, name: "IPA") }

  def create_beer_with_rating(object, style, score)
    beer = FactoryBot.create(:beer, style: style)
    FactoryBot.create(:rating, beer: beer, score: score, user: object[:user])
    beer
  end

  def create_beers_with_many_ratings(object, style, scores)
    scores.each do |score|
      create_beer_with_rating(object, style, score)
    end
  end

  def create_beer_and_rating_for_brewery(brewery, score, style)
    beer = FactoryBot.create(:beer, brewery: brewery, style: style)
    FactoryBot.create(:rating, score: score, beer: beer, user: user)
  end

  describe "favorite brewery" do
    it "has method for determining the favorite brewery" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have a favorite brewery" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "returns the brewery of the only rated beer if only one rating" do
      create_beer_and_rating_for_brewery(brewery1, 20, lager)
      expect(user.favorite_brewery).to eq(brewery1)
    end

    it "returns the brewery with the highest average rating if several rated" do
      create_beer_and_rating_for_brewery(brewery1, 10, lager)
      create_beer_and_rating_for_brewery(brewery1, 20, lager)
      create_beer_and_rating_for_brewery(brewery2, 30, ipa)
      create_beer_and_rating_for_brewery(brewery2, 40, ipa)

      expect(user.favorite_brewery).to eq(brewery2)
    end
  end

  describe "favorite style" do
    it "has method for determining the favorite style" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have a favorite style" do
      expect(user.favorite_style).to eq(nil)
    end

    it "returns the style of the only rated beer if only one rating" do
      create_beer_and_rating_for_brewery(brewery1, 20, ipa)
      expect(user.favorite_style).to eq('IPA')
    end

    it "returns the style with the highest average rating if several rated" do
      create_beer_and_rating_for_brewery(brewery1, 10, ipa)
      create_beer_and_rating_for_brewery(brewery1, 20, ipa)
      create_beer_and_rating_for_brewery(brewery2, 30, lager)
      create_beer_and_rating_for_brewery(brewery2, 40, lager)

      expect(user.favorite_style).to eq('Lager')
    end
  end

  describe "favorite beer" do
    it "has method for determining the favorite beer" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have a favorite beer" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating({ user: user }, lager, 20)
      expect(user.favorite_beer.name).to eq(beer.name)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_many_ratings({ user: user }, lager, [10, 20, 15, 7, 9])
      best = create_beer_with_rating({ user: user }, lager, 25)
      expect(user.favorite_beer.name).to eq(best.name)
    end
  end
  
  it "has the username set correctly" do
    user = User.new(username: "Pekka")
    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create(username: "Pekka")
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
