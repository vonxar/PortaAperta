FactoryBot.define do
  # factory :portfolio do
  #   title { "portfolio_test"}
  #   body { "portfolio_body_test" }
  #   user { FactoryBot.create(:user)}
  # end
  factory :portfolio do
    title { Faker::Lorem.characters(number:5) }
    body { Faker::Lorem.characters(number:10) }
    user { FactoryBot.create(:user)}
  end
end
