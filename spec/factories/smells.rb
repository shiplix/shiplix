FactoryGirl.define do
  factory :smell do
    association :build

    trait :with_class do
      association :subject, factory: :klass
    end

    trait :with_file do
      association :subject, factory: :source_file
    end

    factory :smell_flog, class: Smells::Flog do
    end

    factory :smell_reek, class: Smells::Reek do
    end
  end
end
