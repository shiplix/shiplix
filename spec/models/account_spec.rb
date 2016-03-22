require 'rails_helper'

RSpec.describe Account do
  describe 'uuid' do
    it 'generates uuid on create new account' do
      plan = create(:plan)
      owner = create(:user_owner)

      new_account = Account.new(owner: owner, plan: plan, price: plan.price)
      expect { new_account.save! }.to change { new_account.uuid }.from(nil)
    end
  end
end
