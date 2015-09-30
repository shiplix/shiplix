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

      before do
        source_file = create :source_file, repo: repo
        create :source_file_metric, build: build, source_file: source_file
      end

      it 'show list of source files' do
        get :index, repo_id: repo.to_param

        expect(response.status).to eq 200
        expect(assigns(:source_files)).to be_present
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
