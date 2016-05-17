require "rails_helper"

RSpec.describe OwnersFinder do
  let(:user) { create :user, github_username: 'shiplix' }

  before do
    orgs = [
      Hash[:organization, {login: 'org1'}],
      Hash[:organization, {login: 'org2'}]
    ]

    allow_any_instance_of(GithubApi).to receive(:own_organizations).and_return(orgs)
  end

  it { expect(described_class.new(user).call) }

  context 'when owners exists' do
    context 'when user owner exists' do
      let!(:user_owner) { Owners::User.create!(name: 'shiplix') }

      it { expect(described_class.new(user).call).to eq [user_owner] }

      context 'when org owner exists' do
        let!(:org1) { Owners::Org.create!(name: 'org1') }
        let!(:org2) { Owners::Org.create!(name: 'org2') }

        it { expect(described_class.new(user).call).to match_array [org1, org2, user_owner] }
      end
    end
  end
end
