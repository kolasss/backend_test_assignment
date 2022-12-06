FactoryBot.define do
  factory :car do
    brand
    sequence :model do |n|
      "car #{n}"
    end
    price { 20_000 }
  end
end
