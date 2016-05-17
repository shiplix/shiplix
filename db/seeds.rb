Plan.find_or_create_by(name: 'Test') do |plan|
  plan.months = 1
  plan.price = 10
  plan.repo_limit = 1
end
