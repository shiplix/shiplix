# Brakeman model
class Brakeman < ActiveRecord::Base
  # Potentially dangerous attribute available for mass assignment
  attr_accessible :account_id
end
