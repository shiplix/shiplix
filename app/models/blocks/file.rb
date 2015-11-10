module Blocks
  class File < ::Block
    attr_accessor :content

    has_many :smells
    has_many :locations
    has_many :namespaces, through: :locations
  end
end
