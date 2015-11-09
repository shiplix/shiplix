FactoryGirl.define do
  factory :block do
    association :build, factory: :push

    factory :namespace_block, class: Blocks::Namespace do
      name 'TestKlass'
    end

    factory :file_block, class: Blocks::File do
      name 'test_klass.rb'
    end
  end
end
