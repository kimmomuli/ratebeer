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
end
