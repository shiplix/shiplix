FactoryGirl.define do
  factory :build do
    association :branch
    sequence(:revision) { |n| n.to_s }
    state "finished"

    factory :pull_request, class: Builds::PullRequest do
      sequence(:pull_request_number)
    end

    factory :push, class: Builds::Push do
      payload { build 'payload/push' }
    end
  end
end
