require "rails_helper"

describe ChangesetsFinder do
  let(:build) { create :push }
  let(:finder) { described_class.new(build.branch) }
  let(:results) { finder.call }

  context "when branch is empty" do
    it { expect(results).to be_empty }
  end

  context "when branch has changesets" do
    before { Timecop.freeze(Time.utc(2015, 3, 10)) }

    let!(:c1) { create :changeset, :with_prev_block, build: build, created_at: 1.month.ago }
    let!(:c2) { create :changeset, :with_prev_block, build: build, created_at: 1.day.ago }
    let!(:c3) { create :changeset, :with_prev_block, build: build }
    let!(:c4) { create :changeset, build: build }

    after { Timecop.return }

    it do
      expect(results["2015-02-01".to_date]["2015-02-10".to_date][false][0]).to eq c1
      expect(results["2015-03-01".to_date]["2015-03-09".to_date][false][0]).to eq c2
      expect(results["2015-03-01".to_date]["2015-03-10".to_date][false][0]).to eq c3
      expect(results["2015-03-01".to_date]["2015-03-10".to_date][true][0]).to eq c4
    end
  end
end
