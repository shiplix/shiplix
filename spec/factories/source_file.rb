FactoryGirl.define do
  factory :source_file do
    sequence(:name) { |n| "source_file#{n}.rb" }
    sequence(:path) { |n| "path#{n}/source_file#{n}.rb" }
    association :build
  end
end

