class SourceFileDecorator < Draper::Decorator
  delegate_all
  decorates_association :smells
end
