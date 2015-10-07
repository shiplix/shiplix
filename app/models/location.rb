class Location < ActiveRecord::Base
  belongs_to :namespace, class_name: "::Blocks::Namespace"
  belongs_to :file, class_name: "::Blocks::File"

  validates :namespace, presence: true
  validates :file, presence: true
  validates :position, presence: true
end
