FactoryGirl.define do
  factory :klass do
    association :build
    sequence(:name) { |n| "KlassName#{n}" }
  end
end
