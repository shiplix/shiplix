FactoryGirl.define do
  factory :repo do
    sequence(:github_id) { |n| n }
    sequence(:full_github_name) { |n| "user/repo-#{n}" }
  end
end
