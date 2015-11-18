FactoryGirl.define do
  factory :block do
    association :build, factory: :push

    factory :namespace_block, class: Blocks::Namespace do
      name 'TestKlass'

      trait :in_file do
        transient do
          path nil
          position nil
        end

        after(:create) do |klass, evaluator|
          file = create(:file_block, name: evaluator.path, build: evaluator.build)
          create :location, file: file, namespace: klass, position: evaluator.position
        end
      end
    end

    factory :file_block, class: Blocks::File do
      name 'test_klass.rb'
    end
  end
end
