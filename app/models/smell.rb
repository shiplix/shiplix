class Smell < ActiveRecord::Base
  belongs_to :file, class_name: "SourceFile", required: true

  before_validation :set_position, unless: :position?

  validates :analyzer, presence: true
  validates :check_name, presence: true
  validates :position, presence: true

  def line
    position.begin
  end

  def line=(value)
    self.position = Range.new(value, value) if value
  end

  def set_position
    self.position = 0
  end

  def position=(value)
    if value.is_a?(Integer)
      self.line = value
    else
      super
    end
  end

  # Draper default decorator
  def decorator_class
    "Smells::#{analyzer.camelize}Decorator".constantize
  end
end
