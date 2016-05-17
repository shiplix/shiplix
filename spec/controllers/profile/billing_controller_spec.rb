require "rails_helper"

RSpec.describe Profile::BillingController, type: :controller do
  let!(:user) { create :user }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe '#index' do
    it 'returns success respones' do
      allow_any_instance_of(GithubApi).to receive(:own_organizations).and_return([])

      get :index

      expect(response.status).to eq 200
    end
  end
end
