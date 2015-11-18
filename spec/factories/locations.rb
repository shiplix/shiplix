FactoryGirl.define do
  factory :location do
    association :namespace, factory: :namespace_block
    association :file, factory: :file_block
  end
end
