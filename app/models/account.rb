# Payment hystory
class Account < ActiveRecord::Base
  belongs_to :plan, required: true
  belongs_to :owner, required: true

  validates :uid, presence: true, length: {maximum: 32}
  validates :price, presence: true
end
