class Subscription < ActiveRecord::Base
  include Uuidable

  belongs_to :plan, required: true
  belongs_to :owner, required: true

  validates :price, presence: true
  validates :stripe_subscription_id, presence: true, uniqueness: true

  validates :plan, uniqueness: {scope: :owner}
end
