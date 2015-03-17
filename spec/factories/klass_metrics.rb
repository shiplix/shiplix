FactoryGirl.define do
  factory :klass_metric do
    association :build
    association :klass
  end
end
