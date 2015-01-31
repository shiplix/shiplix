FactoryGirl.define do
  factory :build do
    association :branch
    sequence(:revision) { |n| n.to_s }

    factory :pull_request, class: Builds::PullRequest do
      sequence(:pull_request_number)
    end

    factory :push, class: Builds::Push do
    end
  end
end
