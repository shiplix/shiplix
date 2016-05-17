class Owner < ActiveRecord::Base
  TYPES = %w(user org).freeze

  has_many :repos
  has_one :subscription
  has_one :plan, through: :subscription

  validates :name, presence: true

  TYPES.each do |owner_type|
    define_method("#{owner_type}?") do
      type == "Owners::#{owner_type.camelize}"
    end
  end

  def to_param
    name
  end

  def plan_or_free
    @plan ||= plan || Plans::Free.new
  end
end
