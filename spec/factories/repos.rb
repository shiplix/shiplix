FactoryGirl.define do
  factory :repo do
    sequence(:github_id) { |n| n }
    sequence(:name) { |n| "repo-#{n}" }
    active true

    transient do
      owner_name nil
    end

    association :activator, factory: :user
    association :owner, factory: :org_owner

    after(:build) do |repo, params|
      repo.owner.name = params.owner_name if params.owner_name
    end

    factory :personal_repo, class: Repo do
      association :owner, factory: :user_owner
    end
  end
end
