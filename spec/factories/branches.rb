FactoryGirl.define do
  factory :branch do
    association :repo
    name 'master'
  end
end
