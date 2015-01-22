FactoryGirl.define do
  factory :membership do
    association :user
    association :repo
  end
end
