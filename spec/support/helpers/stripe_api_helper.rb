module StripeApiHelper
  def stripe_customer_hash(id)
    {
      "id": id,
      "object": "customer",
      "account_balance": 0,
      "business_vat_id": nil,
      "created": 1461649715,
      "currency": "usd",
      "default_source": nil,
      "delinquent": false,
      "description": nil,
      "discount": nil,
      "email": nil,
      "livemode": false,
      "metadata": {
      },
      "shipping": nil,
      "sources": {
        "object": "list",
        "data": [

        ],
        "has_more": false,
        "total_count": 0,
        "url": "/v1/customers/#{id}/sources"
      },
      "subscriptions": {
        "object": "list",
        "data": [

        ],
        "has_more": false,
        "total_count": 0,
        "url": "/v1/customers/#{id}/subscriptions"
      }
    }
  end

  def stripe_subscription_hash(id, plan)
    {
      "id": id,
      "object": "subscription",
      "application_fee_percent": nil,
      "cancel_at_period_end": false,
      "canceled_at": nil,
      "current_period_end": 1464241729,
      "current_period_start": 1461649729,
      "customer": "cus_8LDfGUDoPoCAvF",
      "discount": nil,
      "ended_at": nil,
      "metadata": {
      },
      "plan": {
        "id": plan.id,
        "object": "plan",
        "amount": 10,
        "created": 1386249594,
        "currency": "usd",
        "interval": "month",
        "interval_count": 1,
        "livemode": false,
        "metadata": {
        },
        "name": plan.name,
        "statement_descriptor": nil,
        "trial_period_days": nil
      },
      "quantity": 1,
      "start": 1461649729,
      "status": "active",
      "tax_percent": nil,
      "trial_end": nil,
      "trial_start": nil
    }
  end

  def stub_create_stripe_customer(id)
    stub_request(:post, "https://api.stripe.com/v1/customers")
      .to_return(status: 200, body: stripe_customer_hash(id).to_json)
  end

  def stub_create_stripe_subscription(id, subscription_id, plan)
    stub_request(:post, "https://api.stripe.com/v1/customers/#{id}/subscriptions")
      .to_return(status: 200, body: stripe_subscription_hash(subscription_id, plan).to_json)
  end

  def stub_retrieve_stripe_customer(id, body = nil)
    body ||= stripe_customer_hash(id).to_json

    stub_request(:get, "https://api.stripe.com/v1/customers/#{id}")
      .to_return(status: 200, body: body)
  end

  def stub_change_stripe_subscription(id, subscription_id, plan)
    stub_request(:post, "https://api.stripe.com/v1/customers/#{id}/subscriptions/#{subscription_id}")
      .to_return(status: 200, body: stripe_subscription_hash(subscription_id, plan).to_json)
  end
end
