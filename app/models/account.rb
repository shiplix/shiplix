# Payment hystory
class Account < ActiveRecord::Base
  include Uuidable

  belongs_to :plan, required: true
  belongs_to :owner, required: true

  validates :price, presence: true
end
