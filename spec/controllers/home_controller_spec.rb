require 'rails_helper'

describe HomeController, type: :controller do
  let(:user) { create :user }

  it 'shows home page' do
    get :index
    expect(response).to be_success
  end

  it 'redirects signed user to repos page' do
    allow(controller).to receive(:current_user).and_return(user)

    get :index

    expect(response).to redirect_to repos_path
  end
end
