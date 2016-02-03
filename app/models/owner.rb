class Owner < ActiveRecord::Base
  TYPES = %w(user org).freeze

  has_many :repos

  validates :name, presence: true

  TYPES.each do |owner_type|
    define_method("#{owner_type}?") do
      type == "Owners::#{owner_type.camelize}"
    end
  end

  def to_param
    name
  end
end
