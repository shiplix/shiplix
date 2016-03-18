FactoryGirl.define do
  factory :plan do
    sequence(:name) { |n| "plan-#{n}" }
  end
end
