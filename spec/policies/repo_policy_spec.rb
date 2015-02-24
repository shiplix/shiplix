require 'rails_helper'

describe RepoPolicy do
  let(:policy) { described_class.new(user, repo) }
  let(:user) { create :user }
  let(:repo) { create :repo }

  describe '#manage?' do
    context 'when user is membership' do
      context 'when can manage' do
        before { create :membership, user: user, repo: repo, admin: true }
        it { expect(policy.manage?).to be true }
      end

      context 'when cannot manage' do
        before { create :membership, user: user, repo: repo, admin: false }
        it { expect(policy.manage?).to be false }
      end
    end

    context 'when user is not a member' do
      it { expect(policy.manage?).to be false }
    end
  end

  describe '#show?' do
    let(:result) { policy.show? }

    context 'when repo public' do
      let(:repo) { create :repo, private: false }
      it { expect(result).to be true }
    end

    context 'when repo private' do
      let(:repo) { create :repo, private: true }

      context 'when is member' do
        before { create :membership, user: user, repo: repo }
        it { expect(result).to be true }
      end

      context 'when not a member' do
        it { expect(result).to be false }
      end
    end
  end
end
