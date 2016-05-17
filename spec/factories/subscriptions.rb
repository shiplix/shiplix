FactoryGirl.define do
  factory :subscription do
    association :plan
    association :owner
    sequence(:stripe_subscription_id) { |n| "sub_#{n}" }
    price 10
    active_till 1.month.since
  end
end
