require 'rails_helper'

describe ProcessedSource do
  it 'not raise error on rails generator' do
    expect { described_class.new(fixture_path + '/namespaces/rails_generator.rb') }
      .not_to raise_error
  end
end
