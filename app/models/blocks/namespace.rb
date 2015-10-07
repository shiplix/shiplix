module Blocks
  class Namespace < ::Block
    has_many :smells
    has_many :locations
    has_many :files, through: :locations
  end
end
