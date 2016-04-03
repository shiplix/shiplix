module ApplicationHelper
  GPA_CLASSES = {
    4 => 'success',
    3 => 'success',
    2 => 'info',
    1 => 'warning',
    0 => 'danger'
  }.freeze

  GRADE_CLASSES = {
    "A" => 'success',
    "B" => 'info',
    "C" => 'warning',
    "D" => 'danger',
    "F" => 'danger' # TODO: choose the color
  }.freeze

  def grade_badge(grade)
    return unless grade

    content_tag(
      :h4,
      content_tag(
        :span,
        grade,
        class: "label label-#{GRADE_CLASSES[grade]} label-form"
      )
    )
  end

  def gpa_badge(gpa)
    return unless gpa

    content_tag(
      :h4,
      content_tag(
        :span,
        gpa,
        class: "label label-#{GPA_CLASSES[gpa.round]} label-form"
      )
    )
  end

  def navbar_collapsed?
    cookies[:navbar_collapsed] == 'true'
  end
end
