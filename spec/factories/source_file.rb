FactoryGirl.define do
  factory :source_file do
    sequence(:path) { |n| "path#{n}/source_file#{n}.rb" }
    association :repo
  end
end

