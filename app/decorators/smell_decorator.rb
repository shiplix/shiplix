class SmellDecorator < Draper::Decorator
  decorates :smell
  delegate_all
end
