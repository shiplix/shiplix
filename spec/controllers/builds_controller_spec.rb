require 'rails_helper'

describe BuildsController, type: :controller do
  describe '#create' do
    let(:branch) { create(:branch, default: true) }
    let(:repo) { branch.repo }
    let(:build) { create(:push, branch: branch) }
    let(:user) { create :user }

    before do
      allow(controller).to receive(:current_user).and_return(user)
    end

    context 'when user can manage repository' do
      before do
        create :membership, user: user, repo: repo, owner: true
      end

      context 'when github response with revision' do
        before do
          allow_any_instance_of(GithubApi).to receive(:recent_revision).and_return('test_commit_sha')
        end

        it 'render json with meta_id' do
          job_meta = double('meta', meta_id: 'some-meta')

          expect(PushBuildJob).to receive(:enqueue)
            .with(repo.id, 'master', 'test_commit_sha').and_return(job_meta)

          post :create, repo_id: repo.id, branch: 'master'

          expect(JSON.parse(response.body)).to eq({'meta_id' => 'some-meta'})
        end
      end

      context 'when github not send last revision' do
        before do
          allow_any_instance_of(GithubApi).to receive(:recent_revision).and_return(nil)
        end

        it 'respond with 400 status' do
          post :create, repo_id: repo.id, branch: 'master'

          expect(response.status).to eq 400
        end
      end

      it 'respond with 404 status' do
        post :create
        expect(response.status).to eq 404
      end
    end

    context 'when user can not manage repository' do
      it 'respond witn 400 status' do
        post :create, repo_id: repo.id, branch: 'master'
        expect(response.status).to eq 400
      end
    end
  end
end
