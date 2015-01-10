class KlassSmell < ActiveRecord::Base
  belongs_to :klass
  belongs_to :smell

  validates :klass_id, presence: true
  validates :smell_id, presence: true
end
