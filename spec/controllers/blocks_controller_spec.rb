require 'rails_helper'

describe BlocksController, type: :controller do
  let(:user) { create :user }
  let(:repo) { create :repo, active: true }
  let(:branch) { create :branch, repo: repo, default: true }

  let!(:build) { create :push, branch: branch, state: 'finished' }
  let!(:namespace) { create :namespace_block, build: build }
  let!(:membership) { create :membership, repo: repo, user: user }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe '#index' do
    shared_examples 'shows page with blocks' do
      it do
        expect(response.status).to eq 200
        expect(assigns(:blocks)).to eq [namespace]
      end
    end

    shared_examples 'returns 404 page without blocks' do
      it do
        expect(response.status).to eq 404
        expect(assigns(:blocks)).to be_nil
      end
    end

    before { get :index, repo_id: repo.to_param }

    context 'when user is member' do
      it_behaves_like 'shows page with blocks'
    end

    context 'when user is not a member' do
      let!(:membership) { nil }

      context 'when repo is public' do
        it_behaves_like 'shows page with blocks'
      end

      context 'when repo is private' do
        let(:repo) { create :repo, private: true }

        it_behaves_like 'returns 404 page without blocks'
      end
    end

    context 'when repo is not active' do
      let(:repo) { create :repo, active: false }

      it_behaves_like 'returns 404 page without blocks'
    end

    context 'when has many branches' do
      let!(:branch2) { create :branch, repo: repo, name: 'develop' }

      it_behaves_like 'shows page with blocks'
    end

    context 'when has no build' do
      let(:build) { nil }
      let(:namespace) { nil }

      it { expect(response.status).to eq 200 }
    end
  end
end
