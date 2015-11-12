FactoryGirl.define do
  factory :smell do
    trait :with_class do
      association :namespace, factory: :namespace_block
    end

    trait :with_file do
      association :file, factory: :file_block
    end

    factory :smell_flog, class: Smells::Flog do
    end

    factory :smell_reek, class: Smells::Reek do
    end
  end
end
