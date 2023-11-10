require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryBot.create :beer, name: "iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user, username: "Pekka", password: "Foobar1", password_confirmation: "Foobar1" }
  let!(:user2) { FactoryBot.create :user, username: "Matti", password: "Secret123", password_confirmation: "Secret123" }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  describe "favorite style and brewery" do
    before :each do
      FactoryBot.create(:rating, score: 25, beer: beer1, user: user)
      FactoryBot.create(:rating, score: 35, beer: beer2, user: user)
    end

    it "shows user's favorite beer style" do
      visit user_path(user)
      expect(page).to have_content "Favorite Style: Lager" 
    end

    it "shows user's favorite brewery" do
      visit user_path(user)
      expect(page).to have_content "Favorite Brewery: #{brewery.name}" 
    end
  end

  it "when deleted by the user, is removed from the database" do
    rating = FactoryBot.create(:rating, score: 10, beer: beer1, user: user)

    visit user_path(user)
    expect(page).to have_content 'iso 3 10'

    within find("li", text: "iso 3 10") do
        click_link class: "delete-rating-link"
    end

    expect(page).not_to have_content 'iso 3 10'
    expect(Rating.exists?(rating.id)).to be(false)
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  describe 'when multiple ratings have been made' do
    before :each do
      FactoryBot.create(:rating, score: 10, beer: beer1, user: user)
      FactoryBot.create(:rating, score: 20, beer: beer2, user: user2)
    end

    it 'all ratings and their total number are shown on the ratings page' do
      visit ratings_path

      expect(page).to have_content 'iso 3 10'
      expect(page).to have_content 'Karhu 20'
    end

    it "only user's own ratings are shown on user's page" do
      visit user_path(user)

      expect(page).to have_content 'iso 3 10' 
      expect(page).not_to have_content 'Karhu 20'
    end
  end
end
