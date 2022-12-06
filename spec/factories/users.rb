FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "example#{n}@mail.com"
    end
  end
end
