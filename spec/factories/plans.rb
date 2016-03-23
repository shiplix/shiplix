FactoryGirl.define do
  factory :plan do
    sequence(:name) { |n| "plan-#{n}" }
    price 10
    months 1
    repo_limit 1
  end
end
