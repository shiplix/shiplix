FactoryGirl.define do
  factory :user do
    sequence(:github_username) { |n| "user#{n}" }
    sequence(:email_address) { |n| "user#{n}@mail.org" }
    sequence(:access_token) { |n| "assess#{n}" }
  end
end
