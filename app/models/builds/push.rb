module Builds
  class Push < Build
    def payload
      @payload ||= Payload::Push.new(payload_data)
    end

    def payload=(object)
      @payload = object
      self.payload_data = object.to_json
      self.revision = object.revision
      self.prev_revision = object.prev_revision
      self.head_timestamp = object.timestamp
    end
  end
end
