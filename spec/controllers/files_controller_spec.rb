require 'rails_helper'

describe FilesController, type: :controller do
  let(:user) { create :user }
  let(:repo) { create :repo }
  let(:branch) { create :branch, repo: repo, default: true }
  let(:branch2) { create :branch, repo: repo, name: 'develop' }

  let!(:file) { create :file, branch: branch }
  let!(:other_file) { create :file, branch: branch2 }
  let!(:membership) { create :membership, repo: repo, user: user }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  shared_context "checks authorization" do
    shared_examples "returns 200" do
      it { expect(response.status).to eq 200 }
    end

    shared_examples "returns 404" do
      it { expect(response.status).to eq 404 }
    end

    context 'when user is member' do
      it_behaves_like 'returns 200'
    end

    context 'when user is not a member' do
      let!(:membership) { nil }

      context 'when repo is public' do
        it_behaves_like 'returns 200'
      end

      context 'when repo is private' do
        let(:repo) { create :repo, private: true }

        it { expect(response.status).to eq 403 }
      end
    end

    context 'when repo is not active' do
      let(:repo) { create :repo, active: false }

      it_behaves_like 'returns 404'
    end
  end

  describe '#index' do
    context "when all paras valid" do
      before do
        get :index, owner_id: repo.owner.to_param, repo_id: repo.to_param, branch_id: branch.to_param
      end

      include_context "checks authorization"

      it "finds files of a branch" do
        expect(assigns(:files)).to match_array([file])
      end
    end
  end

  describe '#show' do
    context "when all params valid" do
      let(:api) { double("Api", file_contents: "puts 1") }
      let!(:push_build) { create :push, branch: branch }

      before do
        allow(controller).to receive(:api).and_return(api)

        get :show, id: file.to_param, owner_id: repo.owner.to_param, repo_id: repo.to_param, branch_id: branch.to_param
      end

      include_context "checks authorization"

      it "finds file in a branch" do
        expect(assigns(:file)).to eq file
      end

      it "loads file context via api" do
        expect(assigns(:file).content).to eq "puts 1"
      end
    end
  end
end
