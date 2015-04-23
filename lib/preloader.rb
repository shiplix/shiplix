class Preloader
  attr_reader :records

  def initialize(records)
    @records = Array.wrap(records)
  end

  def preload(associations, &block)
    return self unless records.any?

    if block_given?
      Array.wrap(associations).each do |association|
        scope = preload_scope(association, &block) if block_given?
        preloaders_on(association, scope)
      end
    else
      preloaders_on(associations)
    end

    self
  end

  private

  def preloaders_on(associations, scope = nil)
    ActiveRecord::Associations::Preloader.new.
      preload(records, associations, scope)
  end

  def record_class
    @record_class ||= records.first.class
  end

  def preload_scope(association, &block)
    record_class.
      reflect_on_association(association).
      class_name.
      constantize.
      instance_eval(&block)
  end
end
