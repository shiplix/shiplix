require 'rails_helper'

describe SourceFilesController, type: :controller do
  let(:repo) { create :repo, active: true }
  let(:user) { create :user }
  let(:branch) { create :branch, repo: repo, default: true }
  let!(:build) { create :push, branch: branch, state: 'finished' }

  let!(:membership) { create :membership, repo: repo, user: user }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe '#index' do
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
end
