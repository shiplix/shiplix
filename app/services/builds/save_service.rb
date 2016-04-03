module Builds
  class SaveService < ApplicationService
    attr_initialize :build

    def call
      @build.transaction do
        process_files

        @build.files_count = @build.collections.files.size
        @build.save!
      end
    end

    private

    def process_files
      has_prev_build = @build.prev_build.present?
      current_file_ids = []

      @build.collections.files.each do |path, raw_file|
        file = build_file(raw_file)

        raw_smells_size = raw_file.smells.size
        if !file.new_record? && file.smells_count > 0 && raw_smells_size == 0
          delete_not_existing_smells(file, nil)
        end
        file.smells_count = raw_smells_size

        create_changeset(file) if has_prev_build

        file.save! if file.changed?

        create_smells(file, raw_file.smells) if raw_smells_size > 0
        current_file_ids << file.id
      end

      delete_not_existing_files(current_file_ids)
    end

    def build_file(raw_file)
      file = SourceFile.find_by(branch_id: @build.branch_id, path: raw_file.path)
      file ||= SourceFile.new(branch: @build.branch, path: raw_file.path)
      file.pain = raw_file.pain
      file.metrics = raw_file.metrics
      file.grade = raw_file.grade
      file
    end

    def delete_not_existing_files(current_file_ids)
      scope = ::SourceFile.where(branch_id: @build.branch.id)
      scope = scope.where.not(id: current_file_ids) if current_file_ids.present?
      scope.delete_all
    end

    def create_changeset(file)
      return unless (file.new_record? || file.grade_changed?)

      Changeset.create!(
        build: @build,
        path: file.path,
        grade_after: file.grade,
        grade_before: file.new_record? ? nil : file.grade_was
      )
    end

    def create_smells(file, raw_smells)
      current_smell_ids = []

      raw_smells.each do |raw_smell|
        smell = Smell.find_by(file_id: file.id, fingerprint: raw_smell.fingerprint)
        smell ||= Smell.create!(
          file: file,
          position: raw_smell.position,
          analyzer: raw_smell.analyzer,
          check_name: raw_smell.check_name,
          message: raw_smell.message,
          pain: raw_smell.pain,
          data: raw_smell.data,
          fingerprint: raw_smell.fingerprint
        )

        current_smell_ids << smell.id
      end

      delete_not_existing_smells(file, current_smell_ids)
    end

    def delete_not_existing_smells(file, current_smell_ids)
      scope = ::Smell.where(file_id: file.id)
      scope = scope.where.not(id: current_smell_ids) if current_smell_ids.present?
      scope.delete_all
    end
  end
end
