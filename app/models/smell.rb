class Smell < ActiveRecord::Base
  IMPORTANCE = %w(Smells::Flog Smells::Flay Smells::Reek Smells::Brakeman).freeze

  belongs_to :namespace, class_name: "::Blocks::Namespace"
  belongs_to :file, class_name: "::Blocks::File"

  validates :file, presence: true
  validates :position, presence: true
end
