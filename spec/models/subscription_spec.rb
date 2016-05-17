require 'rails_helper'

RSpec.describe Subscription do
  describe 'uuid' do
    it 'generates uuid on create new account' do
      plan = create(:plan)
      owner = create(:user_owner)

      new_account = described_class.new(owner: owner, plan: plan, price: plan.price, stripe_subscription_id: 123)
      expect { new_account.save! }.to change { new_account.uuid }.from(nil)
    end
  end

  describe "validations" do
    let(:plan) { create :plan }
    let(:owner) { create :org_owner }

    it 'should be unique on plan and owner' do
      described_class.create(owner: owner, plan: plan)

      expect(described_class.new(owner: owner, plan: plan)).not_to be_valid
    end
  end
end
