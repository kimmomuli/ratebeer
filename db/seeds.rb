# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
b1 = Brewery.create name: "Koff", year: 1897
b2 = Brewery.create name: "Malmgard", year: 2001
b3 = Brewery.create name: "Weihenstephaner", year: 1040

b1.beers.create name: "Iso 3", style: "Lager"
b1.beers.create name: "Karhu", style: "Lager"
b1.beers.create name: "Tuplahumala", style: "Lager"
b2.beers.create name: "Huvila Pale Ale", style: "Pale Ale"
b2.beers.create name: "X Porter", style: "Porter"
b3.beers.create name: "Hefeweizen", style: "Weizen"
b3.beers.create name: "Helles", style: "Lager"

c1 = BeerClub.create name: "Helsinki Beer Lovers", founded: 2010, city: "Helsinki"
c2 = BeerClub.create name: "Tampere Brew Enthusiasts", founded: 2015, city: "Tampere"

u1 = User.create username: "john_doe", password_digest: "johndoe123"
u2 = User.create username: "jane_smith", password_digest: "janesmith456"

Membership.create beer_club: c1, user: u1
Membership.create beer_club: c2, user: u2

beer1 = Beer.find_by(name: "Iso 3")
beer2 = Beer.find_by(name: "Huvila Pale Ale")

Rating.create score: 5, beer: beer1, user: u1
Rating.create score: 4, beer: beer2, user: u2