module Uuidable
  extend ActiveSupport::Concern

  included do
    before_create :generate_uuid
  end

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end

  def generate_uuid!
    save! if generate_uuid
  end
end
