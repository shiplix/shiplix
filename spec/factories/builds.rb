FactoryGirl.define do
  factory :build do
    association :branch
    sequence(:revision) { |n| n }
    sequence(:pull_request_number) { |n| n }

    factory :pull_request, class: Builds::PullRequest do
    end

    factory :push, class: Builds::Push do
    end
  end
end
