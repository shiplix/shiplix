module Owners
  # Subscribe owner to the plan.
  # If owner already have a plan, updates subscription to this plan.
  #
  # Example:
  #
  # Users::SubscribeToPlan
  #   .call(owner: owner, plan: plan, card_token: stripe_card_token)
  #
  # TODO: we should rescue from stripe api error, for exsample if stripe
  # not responding, log error to NR and, show error message for users.
  class SubscribeToPlan
    include Interactor

    delegate :owner, :plan, :card_token, to: :context

    def call
      if owner.stripe_customer_id.present?
        stripe_customer = find_customer
      else
        stripe_customer = create_customer
      end

      if create_subscription?
        create_subscription!(stripe_customer)
      elsif change_plan?
        update_subscription(stripe_customer)
      else
        context.fail!
      end
    end

    private

    def create_customer
      Stripe::Customer.create(
        metadata: { id: owner.id, name: owner.name }, card: card_token).tap do |stripe_customer|
          owner.update(stripe_customer_id: stripe_customer.id)
        end
    end

    def find_customer
      Stripe::Customer.retrieve(owner.stripe_customer_id)
    end

    def create_subscription?
      owner.plan.nil?
    end

    def change_plan?
      owner.plan.present? && owner.plan != plan
    end

    def create_subscription!(customer)
      stripe_subscription = customer
                              .subscriptions
                              .create(plan: plan.id, metadata: {owner_id: owner.id})

      owner.create_subscription!(plan_attrs.merge!(stripe_subscription_id: stripe_subscription.id))
    end

    def update_subscription(customer)
      stripe_subscription = customer.subscriptions.find { |sub| sub.id == owner.subscription.stripe_subscription_id }
      stripe_subscription.plan = plan.id
      stripe_subscription.save

      owner.subscription.update_attributes!(plan_attrs)
    end

    def plan_attrs
      {
        plan: plan,
        price: plan.price,
        active_till: Time.current.advance(months: plan.months).end_of_day
      }
    end
  end
end
