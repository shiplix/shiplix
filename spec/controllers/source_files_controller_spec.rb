require 'rails_helper'

describe SourceFilesController, type: :controller do
  let(:repo) { create :repo, active: true }
  let(:user) { create :user }
  let(:branch) { create :branch, repo: repo, default: true }

  let!(:membership) { create :membership, repo: repo, user: user }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe '#index' do
    context 'when repo has build' do
      let!(:build) { create :push, branch: branch, state: 'finished' }
      let!(:file) { create :file_block, build: branch.builds.first }

      it 'show list of source files' do
        get :index, repo_id: repo.to_param

        expect(response.status).to eq 200
        expect(assigns(:source_files)).to eq [file]
      end
    end

    context 'when repo has not build' do
      it 'not fail in 500' do
        get :index, repo_id: repo.to_param

        expect(response.status).to eq 200
      end
    end
  end
end
