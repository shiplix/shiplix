require "rails_helper"

RSpec.describe PlanSubscriptionType do
  let(:plan) { create :plan }

  describe '#validation' do
    it 'valid' do
      expect(PlanSubscriptionType.new(
        card_number: 4444_4444_4444_4444,
        cvc: 888,
        exp_month: 1,
        exp_year: 2017,
        token: 'tk_123123',
        plan_id: plan.id
      )).to be_valid
    end

    it 'does not valid' do
      expect(PlanSubscriptionType.new).not_to be_valid
    end
  end

  describe '#plan' do
    it 'returns plan' do
      expect(described_class.new(plan_id: plan.id).plan).to eq plan
    end
  end
end
