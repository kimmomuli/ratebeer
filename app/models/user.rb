class User < ApplicationRecord
  include RatingAverage

  has_secure_password validations: false

  validates :username, uniqueness: true,
                       length: { minimum: 3, maximum: 30 }

  validates :password, length: { minimum: 4 },
                       format: { with: /(?=.*[A-Z])(?=.*\d)/,
                                 message: 'should have at least one uppercase letter and one digit' }

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  def favorite_style
    return nil if ratings.empty?

    style_ratings = ratings.joins(beer: :style).group('styles.name').average('ratings.score')
    style_ratings.max_by { |_style, avg_rating| avg_rating }&.first
  end

  def favorite_brewery
    return nil if ratings.empty?

    brewery_ratings = ratings.joins(beer: :brewery).group('breweries.name').average(:score)
    best_brewery_name = brewery_ratings.max_by { |_name, avg_rating| avg_rating }[0]

    Brewery.find_by(name: best_brewery_name)
  end

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).first.beer
  end
end
