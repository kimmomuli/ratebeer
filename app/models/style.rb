class Style < ApplicationRecord
  include RatingAverage
  include TopRatingCalculations

  has_many :beers
  has_many :ratings, through: :beers
end
