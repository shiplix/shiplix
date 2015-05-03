FactoryGirl.define do
  factory 'payload/push' do
    skip_create

    revision { SecureRandom.hex }
    prev_revision { SecureRandom.hex }

    initialize_with do
      Payload::Push.new(
        {
          ref: 'refs/heads/master',
          head_commit: {id: revision,
                        timestamp: 1.day.ago.to_s},
          before: prev_revision
        }.to_json
      )
    end
  end
end
