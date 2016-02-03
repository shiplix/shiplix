FactoryGirl.define do
  factory :owner do
    sequence(:name) { |n| "owner-#{n}" }

    factory :user_owner, class: Owners::User do
      after(:build) do |owner, _evaluator|
        create :user, github_username: owner.name
      end
    end

    factory :org_owner, class: Owners::Org do
    end
  end
end
