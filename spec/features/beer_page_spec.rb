require 'rails_helper'

describe 'Beers', type: :feature do
  before :each do
    FactoryBot.create(:brewery, name: "Koff")
  end

  it 'beer can be added with a valid name' do
    visit new_beer_path

    fill_in('beer[name]', with: 'Koff III')
    select('Lager', from: 'beer[style]')
    select('Koff', from: 'beer[brewery_id]')
    
    click_button('Create Beer')

    expect(page).to have_content 'Beer was successfully created.'
    expect(Beer.count).to eq(1)
  end

  it 'shows an error if name is not valid' do
    visit new_beer_path

    fill_in('beer[name]', with: '')
    select('Lager', from: 'beer[style]')
    select('Koff', from: 'beer[brewery_id]')

    click_button('Create Beer')

    expect(page).to have_content "Name can't be blank"
    expect(Beer.count).to eq(0)
  end
end