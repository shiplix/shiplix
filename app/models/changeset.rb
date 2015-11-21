class Changeset < ActiveRecord::Base
  belongs_to :build
  belongs_to :block
  belongs_to :prev_block, class_name: 'Block'

  validates :build, :block, presence: true
end
