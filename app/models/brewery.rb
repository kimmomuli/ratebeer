class Brewery < ApplicationRecord
  include RatingAverage

  validates :name, presence: true
  validate :year_must_be_valid
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  private

  def year_must_be_valid
    current_year = Time.now.year
    unless year.is_a?(Integer) && year >= 1040 && year <= current_year
      errors.add(:year, "must be an integer between 1040 and #{current_year}")
    end
  end
end
