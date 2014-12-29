class Build < ActiveRecord::Base
  belongs_to :repo
  #has_many :violations, dependent: :destroy

  validates :repo_id, presence: true

end
