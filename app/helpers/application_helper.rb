module ApplicationHelper
  RATING_CLASSES = {
    1 => 'success',
    2 => 'info',
    3 => 'warning',
    4 => 'danger',
    5 => 'danger' # TODO: choose the color
  }.freeze

  def rating_badge(rating)
    return unless rating

    level = t('rating.levels')[rating]
    title = t('rating.titles')[rating]
    content_tag(
      :h4,
      content_tag(
        :span,
        "#{level} [#{title}]",
        class: "label label-#{RATING_CLASSES[rating]} label-form"
      )
    )
  end

  def navbar_collapsed?
    cookies[:navbar_collapsed] == 'true'
  end
end
