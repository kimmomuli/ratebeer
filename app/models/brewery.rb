class Brewery < ApplicationRecord
  include RatingAverage
  include TopRatingCalculations

  validates :name, presence: true
  validate :year_must_be_valid
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  scope :active, -> { where active: true }
  scope :retired, -> { where active: [nil, false] }

  private

  def year_must_be_valid
    current_year = Time.now.year
    return if year.is_a?(Integer) && year >= 1040 && year <= current_year

    errors.add(:year, "must be an integer between 1040 and #{current_year}")
  end
end
