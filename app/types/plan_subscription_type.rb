class PlanSubscriptionType
  include ApplicationTypeWithoutActiveRecord

  attribute :card_number, Fixnum
  attribute :cvc, Fixnum
  attribute :exp_month, Fixnum
  attribute :exp_year, Fixnum
  attribute :token, String
  attribute :plan_id, Fixnum

  validates :card_number, presence: true
  validates :cvc, presence: true
  validates :exp_month, presence: true
  validates :exp_year, presence: true
  validates :plan_id, presence: true

  def plan
    Plan.find(plan_id)
  end
end
