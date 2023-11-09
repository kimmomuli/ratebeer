FactoryBot.define do
  factory :user do
    username { "Pekka" }
    password { "Foobar1" }
    password_confirmation { "Foobar1" }
  end

  factory :brewery do
    name { "anonymous" }
    year { 1900 }
  end

  factory :beer do
    name { "anonymous" }
    brewery
    style 
  end

  factory :style do
    name { "Lager" }
    description { "A style with a smooth, crisp finish." }
  end

  factory :rating do
    score { 10 }
    beer
    user
  end
end