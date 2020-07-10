FactoryBot.define do
  # factory :user do 
  #   name {"test"}
  #   sequence(:email) { |n| "test#{n}@example.com"}
  #   password {"password"}
  #   password_confirmation { 'password' }
  #   introduction { "testtest" }
  # end
  factory :user do 
  name { Faker::Lorem.characters(number:5) }
    email { Faker::Internet.email }
    introduction { Faker::Lorem.characters(number:10) }
    password { 'password' }
    password_confirmation { 'password' }
end
end