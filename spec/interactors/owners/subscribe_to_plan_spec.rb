require 'rails_helper'

RSpec.describe Owners::SubscribeToPlan do
  include StripeApiHelper

  let(:plan) { create :plan, months: 1 }
  let!(:owner) { create :org_owner, name: 'shiplix' }

  before do
    Timecop.freeze(2016, 1, 1)

    allow_any_instance_of(GithubApi).to receive(:own_organizations)
      .and_return([Hash[:organization, {login: 'shiplix'}]])
  end

  after { Timecop.return }

  let(:stripe_customer_id) { "cus_8LDfGUDoPoCAvF".freeze }
  let(:stripe_subscription_id) { "sub_8L5E9SksGH6zyx".freeze }

  before do
    stub_create_stripe_customer(stripe_customer_id)
    stub_create_stripe_subscription(stripe_customer_id, stripe_subscription_id, plan)
  end

  context 'when owner is a new stripe customer' do
    it 'create subscription and save stripe_customer_id' do
      described_class.call(owner: owner, plan: plan, token: 'tk_0123456')

      expect(owner.stripe_customer_id).to eq stripe_customer_id

      expect(owner.subscription.plan).to eq plan
      expect(owner.subscription.stripe_subscription_id).to eq stripe_subscription_id
      expect(owner.subscription.active_till).to eq Time.zone.local(2016, 2, 1).end_of_day
    end
  end

  context 'when owner already have customer_stipe_id attr' do
    before do
      owner.stripe_customer_id = stripe_customer_id
    end

    it 'creates subscription' do
      stub_retrieve_stripe_customer(stripe_customer_id)

      described_class.call(owner: owner, plan: plan, token: 'tk_0123456')

      expect(owner.subscription.plan).to eq plan
      expect(owner.subscription.stripe_subscription_id).to eq stripe_subscription_id
      expect(owner.subscription.active_till).to eq Time.zone.local(2016, 2, 1).end_of_day
    end

    context 'when owner already have subscription for this plan' do
      before do
        create :subscription, owner: owner, plan: plan, stripe_subscription_id: stripe_subscription_id

        resp = stripe_customer_hash(stripe_customer_id).tap do |customer|
          customer[:subscriptions][:data] = [stripe_subscription_hash(stripe_subscription_id, plan)]
        end

        stub_retrieve_stripe_customer(stripe_customer_id, resp.to_json)
      end

      it 'does not create dublicated subscription' do
        expect(described_class.call(owner: owner, plan: plan, token: 'tk_0123456'))
          .not_to be_success
      end

      it'change subscription to another plan' do
        another_plan = create(:plan, months: 3)

        stub_change_stripe_subscription(stripe_customer_id, stripe_subscription_id, another_plan)

        expect { described_class.call(owner: owner, plan: another_plan, token: 'tk_0123456') }
          .to change { owner.subscription.plan }.to(another_plan)

        expect(owner.subscription.active_till).to eq Time.zone.local(2016, 4, 1).end_of_day
      end
    end
  end
end
