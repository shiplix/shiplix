require 'rails_helper'

describe RepoPolicy do
  let(:policy) { described_class.new(user, repo) }
  let(:user) { create :user }
  let(:owner) { create :user_owner }
  let(:repo) { create :repo, owner: owner }

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

  describe '#activate?' do
    context 'when user is not a member' do
      it { expect(policy.activate?).to eq false }
    end

    context 'when user can manage' do
      before { create :membership, user: user, repo: repo, admin: true }

      context 'when user have free plan' do
        it 'can activate public repo' do
          repo.private = false
          expect(policy.activate?).to eq true
        end

        it 'can`t activate private repo' do
          repo.private = true
          expect(policy.activate?).to eq false
        end
      end

      context 'when user have paid plan' do
        let!(:plan) do
          repo.owner.create_plan!(name: 'Test', price: 10, repo_limit: 1)
        end

        it 'can activate public repo' do
          repo.private = false
          expect(policy.activate?).to eq true
        end

        it 'can activate private repo' do
          repo.private = true
          expect(policy.activate?).to eq true
        end

        context 'when repo limit reached' do
          before do
            create(:repo, private: true, active: true, owner: owner).tap do |another_repo|
              create :membership, user: user, repo: another_repo, admin: true
            end
          end

          it 'can activate public repo' do
            repo.private = false
            expect(policy.activate?).to eq true
          end

          it 'can`t active private repos more than plan limit' do
            repo.private = true
            expect(policy.activate?).to eq false
          end
        end
      end
    end
  end
end
