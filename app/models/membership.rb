class Membership < ActiveRecord::Base
  belongs_to :repo
  belongs_to :user

  validates :repo_id, presence: true
  validates :user_id, presence: true
end
