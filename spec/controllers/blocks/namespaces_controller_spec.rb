require 'rails_helper'

describe Blocks::NamespacesController, type: :controller do
  let(:user) { create :user }
  let(:repo) { create :repo, active: true }
  let(:branch) { create :branch, repo: repo, default: true }

  let!(:build) { create :push, branch: branch, state: 'finished' }
  let(:namespace) { create :namespace_block, build: build }
  let!(:membership) { create :membership, repo: repo, user: user }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe '#show' do
    context 'when repo has build' do
      it 'renders namespace page' do
        get :show, id: namespace.to_param, repo_id: repo.to_param, build_id: build.to_param

        expect(response.status).to eq 200
      end
    end
  end
end
