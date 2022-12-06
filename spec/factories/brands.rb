FactoryBot.define do
  factory :brand do
    sequence :name do |n|
      "brand #{n}"
    end
  end
end
