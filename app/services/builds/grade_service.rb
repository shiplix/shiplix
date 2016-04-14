module Builds
  class GradeService < ApplicationService
    NUMERIC_GRADES = {
      "A" => 4,
      "B" => 3,
      "C" => 2,
      "D" => 1,
      "F" => 0
    }.freeze

    attr_initialize :build

    def call
      total_grades = 0
      @build.collections.files.each do |_, file|
        grade = grade_for_pain(file.pain)
        file.grade = grade
        total_grades += NUMERIC_GRADES[grade]
      end

      files_count = @build.collections.files.size
      @build.gpa = (total_grades / files_count.to_f).round(1) if files_count > 0
    end

    private

    def grade_for_pain(pain)
      if pain < 2_000_000
        "A".freeze
      elsif pain < 4_000_000
        "B".freeze
      elsif pain < 8_000_000
        "C".freeze
      elsif pain < 16_000_000
        "D".freeze
      else
        "F".freeze
      end
    end
  end
end
