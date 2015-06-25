FactoryGirl.define do
  factory :changeset do
    association :build

    trait :with_class do
      association :subject, factory: :klass
    end

    rating 1
    prev_rating 0
  end
end
