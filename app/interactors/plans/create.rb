module Plans
  # Create plan and save this plan in stripe.
  #
  # @example:
  #   Plans::Create.call(name: 'Test', months: 1, price: 10.00, repo_limit: 1)
  class Create
    include Interactor

    def call
      plan = Plan.new(context.to_h)

      Plan.transaction do
        if plan.save
          Stripe::Plan.create(
            amount: plan.price.to_i * 100,
            currency: "USD",
            name: plan.name,
            id: plan.id,
            interval: "month",
            interval_count: plan.months,
            statement_descriptor: "Shiplix #{plan.name}"
          )
        else
          context.fail!(errors: plan.errors)
        end
      end
    end
  end
end
