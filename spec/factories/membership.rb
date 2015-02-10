FactoryGirl.define do
  factory :membership do
    association :user
    association :repo
    admin true
  end
end
