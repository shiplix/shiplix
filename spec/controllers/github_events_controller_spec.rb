require 'rails_helper'

describe GithubEventsController, type: :controller do
  describe 'payload validation' do
    let(:repo) { create :repo }
    let(:payload) do
      {
        repository: {
          id: repo.github_id
        }
      }
    end

    before do
      request.headers['HTTP_X_GITHUB_EVENT'] = 'push'
      allow(controller).to receive(:github_signature).and_return('sha1=valid')
    end

    context 'when signature invalid' do
      it 'does not launch build job' do
        expect(Builds::LaunchJob).not_to receive(:enqueue)

        request.headers['HTTP_X_HUB_SIGNATURE'] = 'sha1=invalid'
        post :create, payload: payload

        expect(response.status).to eq 400
      end
    end

    context 'when signature valid' do
      it 'launches build job' do
        expect(Builds::LaunchJob).to receive(:enqueue)

        request.headers['HTTP_X_HUB_SIGNATURE'] = 'sha1=valid'
        post :create, payload: payload

        expect(response.status).to eq 200
      end
    end
  end
end
