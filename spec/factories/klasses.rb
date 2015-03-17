FactoryGirl.define do
  factory :klass do
    association :repo
    sequence(:name) { |n| "KlassName#{n}" }

    trait :with_metrics do
      transient do
        build nil
      end

      after(:create) do |klass, evaluator|
        build = evaluator.build || create(:push_build, repo: klass.repo)
        create :klass_metric, klass: klass, build: build
      end
    end

    # Example:
    #   create create :klass_in_file, line: 1, path: 'flay/dirty.rb', name: 'Test', build: build
    factory :klass_in_file do
      transient do
        path nil
        line 1
        line_end nil
        build nil
      end

      after(:create) do |klass, evaluator|
        if evaluator.line_end.nil?
          line_end = evaluator.line + 1
        else
          line_end = evaluator.line_end
        end

        source_file = create(:source_file, path: evaluator.path, repo: klass.repo)

        create(:klass_source_file,
               build: evaluator.build,
               klass: klass,
               source_file: source_file,
               line: evaluator.line,
               line_end: line_end)
      end
    end
  end
end
