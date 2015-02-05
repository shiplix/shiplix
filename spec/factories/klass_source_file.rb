FactoryGirl.define do
  factory :klass_source_file do
    association :klass
    association :source_file
  end
end
