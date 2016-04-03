require 'rails_helper'

describe BuildsController, type: :controller do
  describe '#create' do
    let(:branch) { create(:branch, default: true) }
    let(:repo) { branch.repo }
    let(:build) { create(:push, branch: branch) }
    let(:user) { create :user }
    let(:meta_id) { 'some-meta' }
    let(:recent_service) { instance_double('Builds::EnqueueRecentService', call: meta_id) }
    let!(:recent_service_class) { class_double(Builds::EnqueueRecentService, new: recent_service).as_stubbed_const }

    before do
      allow(controller).to receive(:current_user).and_return(user)
    end

    context 'when user can manage repository' do
      before do
        create :membership, user: user, repo: repo, admin: true
      end

      context 'when github response with revision' do
        it 'render json with meta_id' do
          post :create, repo_id: repo.id, branch: 'master'

          expect(JSON.parse(response.body)).to eq('meta_id' => 'some-meta')
        end
      end

      context 'when github not send last revision' do
        let(:meta_id) { nil }

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
        expect(response.status).to eq 403
      end
    end
  end
end
