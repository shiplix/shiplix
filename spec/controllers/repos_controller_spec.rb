require 'rails_helper'

describe ReposController, type: :controller do
  let(:user) { create :user }

  before do
    session[:remember_token] = user.remember_token
  end

  describe '#index' do
    context 'when user has no repos' do
      before { get :index }
      it { expect(assigns(:repos)).to be_empty }
    end

    context 'when has repos' do
      let(:repo1) { create :repo, active: true }
      let(:repo2) { create :repo, active: false }
      let(:repo3) { create :repo, active: false }

      before do
        create :membership, user: user, repo: repo1, admin: false
        create :membership, user: user, repo: repo2, admin: false
        create :membership, user: user, repo: repo3, admin: true
        create :membership, user: create(:user), repo: create(:repo, active: true)

        get :index
      end

      Then { expect(assigns(:repos).size).to eq 2 }
      And { expect(assigns(:repos)[0]).to eq repo1 }
      And { expect(assigns(:repos)[1]).to eq repo3 }
    end
  end
end
