module ApplicationHelper
  RATING_CLASSES = {
    1 => 'success',
    2 => 'info',
    3 => 'warning',
    4 => 'danger',
    5 => 'danger' # TODO: choose the color
  }.freeze

  def block_rating_badge(rating)
    return unless rating
    rating = rating.round

    content_tag(
      :h4,
      content_tag(
        :span,
        t('rating.levels')[rating],
        class: "label label-#{RATING_CLASSES[rating]} label-form"
      )
    )
  end

  def build_rating_badge(rating)
    return unless rating

    content_tag(
      :h4,
      content_tag(
        :span,
        5 - rating,
        class: "label label-#{RATING_CLASSES[rating.round]} label-form"
      )
    )
  end

  def navbar_collapsed?
    cookies[:navbar_collapsed] == 'true'
  end
end
