FactoryGirl.define do
  factory :file, class: SourceFile do
    sequence(:path) { |n| "lib/test#{n}.rb" }
  end
end
