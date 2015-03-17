FactoryGirl.define do
  factory :source_file_metric do
    association :build
    association :source_file
  end
end
