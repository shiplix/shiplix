require 'rails_helper'

describe KlassesController, type: :controller do
  let(:repo) { create :repo, active: true }
  let(:user) { create :user }
  let(:branch) { create :branch, repo: repo, default: true }
  let(:build) { create :push, branch: branch, state: 'finished' }

  let!(:membership) { create :membership, repo: repo, user: user }
  let!(:klass) { create :klass, build: build }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe '#index' do
    before { get :index, repo_id: repo.id }

    context 'when user is member' do
      Then { expect(assigns(:klasses)).to be_present }
      And { expect(response.status).to eq 200 }
    end

    context 'when user is not a member' do
      let!(:membership) { nil }

      Then { expect(assigns(:klasses)).to be_nil }
      And { expect(response.status).to eq 404 }
    end

    context 'when repo is not active' do
      let(:repo) { create :repo, active: false }

      Then { expect(assigns(:klasses)).to be_nil }
      And { expect(response.status).to eq 404 }
    end

    context 'when has many branches' do
      let!(:branch2) { create :branch, repo: repo, name: 'develop' }

      Then { expect(assigns(:klasses)).to be_present }
      And { expect(response.status).to eq 200 }
    end

    context 'when has many builds' do
      let(:build2) { create :push, branch: branch, state: 'finished' }
      let!(:klass) { create :klass, build: build2 }

      Then { expect(assigns(:klasses)).to be_present }
      And { expect(response.status).to eq 200 }
    end
  end
end
