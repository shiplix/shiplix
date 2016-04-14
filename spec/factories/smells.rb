FactoryGirl.define do
  factory :smell do
    analyzer "flog"
    check_name "overall"
    pain 1_000_000
    line 1

    association :file
  end
end
