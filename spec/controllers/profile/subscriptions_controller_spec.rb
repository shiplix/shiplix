require "rails_helper"

RSpec.describe Profile::SubscriptionsController, type: :controller do
  include StripeApiHelper

  let!(:owner) { create :org_owner, name: 'shiplix' }
  let(:user) { create :user, github_username: "shiplix" }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    allow_any_instance_of(GithubApi).to receive(:own_organizations).and_return([Hash[:organization, {login: owner.name}]])
  end

  describe "#new" do
    it 'returns success respones' do
      get :new, billing_id: owner

      expect(response.status).to eq 200
    end

    context 'when user can`t manage owner' do
      it 'respond with 404 error'  do
        get :new, billing_id: 'another-owner'

        expect(response.status).to eq 404
      end
    end
  end

  describe "#create" do
    let(:plan) { create :plan }

    let(:params) do
      {
        billing_id: owner,
        PlanSubscriptionType.model_name.param_key => {
          card_number: "4242424242424242",
          cvc: "333",
          exp_month: '1',
          exp_year: '2016',
          token: 'tk_123123',
          plan_id: plan.id
        }
      }
    end

    it "redirects back with success message" do
      stub_create_stripe_customer('cus_123')
      stub_create_stripe_subscription('cus_123', 'sub_123', plan)

      post :create, params

      expect(response).to redirect_to(new_profile_billing_subscription_url)
      expect(flash[:success]).to be_present
    end

    context 'when user can`t manage owner' do
      it 'respond with 404 error'  do
        params[:billing_id] = 'another-owner'

        post :create, params

        expect(response.status).to eq 404
      end
    end

    context "when payment form is invalid" do
      before do
        params[PlanSubscriptionType.model_name.param_key][:card_number] = ''
      end

      it "renders new template" do
        post :create, params

        expect(response).to render_template(:new)
      end
    end
  end
end
