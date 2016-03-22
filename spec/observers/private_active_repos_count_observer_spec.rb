require 'rails_helper'

RSpec.describe PrivateActiveReposCountObserver do
  context 'when create repo' do
    it do
      repo = create :repo, private: true, active: true

      expect(repo.owner.active_private_repos_count).to eq 1
    end

    it do
      repo = create :repo, private: false, active: true

      expect(repo.owner.active_private_repos_count).to eq 0
    end

    it do
      repo = create :repo, private: false, active: false

      expect(repo.owner.active_private_repos_count).to eq 0
    end

    it do
      repo = create :repo, private: true, active: false

      expect(repo.owner.active_private_repos_count).to eq 0
    end
  end

  context 'when private repo change activity' do
    let(:repo) { create :repo, private: true, active: false }

    it do
      expect { repo.update_attributes(active: true) }
        .to change { repo.owner.active_private_repos_count }
        .from(0).to(1)

      expect { repo.update_attributes(active: false) }
        .to change { repo.owner.active_private_repos_count }
        .from(1).to(0)
    end
  end

  context 'when active repo change state' do
    let!(:repo) { create :repo, private: false, active: true }

    it do
      expect { repo.update_attributes(private: true) }
        .to change { repo.owner.active_private_repos_count }
        .from(0).to(1)

      expect { repo.update_attributes(private: false) }
        .to change { repo.owner.active_private_repos_count }
        .from(1).to(0)
    end
  end

  context 'when inactive repo change state' do
    let!(:repo) { create :repo, private: false, active: false }

    it do
      expect { repo.update_attributes(private: true) }
        .not_to change { repo.owner.active_private_repos_count }
    end
  end
end
