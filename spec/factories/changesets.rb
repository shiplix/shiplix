FactoryGirl.define do
  factory :changeset do
    association :build
    association :block, factory: :namespace_block

    trait :with_prev_block do
      association :prev_block, factory: :namespace_block
    end
  end
end
