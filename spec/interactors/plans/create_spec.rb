require 'rails_helper'

RSpec.describe Plans::Create do
  context 'when assign valid attributes' do
    let(:attributes) do
      {
        months: 1,
        price: 10,
        repo_limit: 1,
        name: 'Test plan'
      }
    end

    it 'creates new plan' do
      stub_request(:post, 'https://api.stripe.com/v1/plans')
        .to_return(status: 200, body: {}.to_json)

      expect { described_class.call(attributes) }.to change { Plan.count }.by(1)
    end

    context 'when stripe raise error' do
      it 'does not create plan' do
        stub_request(:post, 'https://api.stripe.com/v1/plans').to_timeout

        expect { described_class.call(attributes) }.to raise_error
        expect(Plan.count).to eq 0
      end
    end
  end

  context 'when assigns invalid attributes' do
    let(:attributes) do
      {
        name: 'Test plan'
      }
    end

    it 'does not create plan' do
      result = described_class.call(attributes)

      expect(result.errors).to be_present
      expect(Plan.count).to eq 0
    end
  end
end
