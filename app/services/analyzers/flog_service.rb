require 'flog'

module Analyzers
  class FlogService < BaseService
    HIGH_COMPLEXITY_SCORE_THRESHOLD = 10 # TODO: change this!

    attr_reader :flog

    def call
      @flog = Flog.new(all: true, continue: true, methods: true)

      # TODO: move SourceLocator to Build?
      SourceLocator.new(build.locator.revision_path.to_s).paths.each do |path|
        add_smells_to(path)
      end
    end

    private

    # TODO: refactor this shit
    def add_smells_to(path)
      flog.reset
      flog.flog(path)
      flog.calculate

      flog.scores.each do |klass_name, total_score|
        klass = build.klasses.where(name: klass_name).first || build.klasses.create!(name: klass_name)

        rel_path = relative_path(path)
        unless klass.source_files.where(path: rel_path).exists?
          source_file = build.source_files.find_or_create_by!(path: rel_path)
          KlassSourceFile.create!(klass_id: klass.id, source_file_id: source_file.id)
        end

        klass.complexity = klass.complexity.to_i + total_score.round

        flog.method_scores[klass_name].each do |klass_method, score|
          score = score.round
          if score >= HIGH_COMPLEXITY_SCORE_THRESHOLD
            create_smell(klass, klass_method, score)
          end
        end

        klass.save!
      end
    end

    def create_smell(klass, klass_method, score)
      path_line = flog.method_locations[klass_method]
      return if path_line.blank?

      path, line = path_line.split(':')
      method_name = klass_method.split('#').last

      smell = Smells::Flog.create!(
        build: build,
        score: score,
        method_name: method_name
      )

      smell.locations.create!(
        path: relative_path(path),
        line: line.to_i
      )

      # TODO: wtf?
      KlassSmell.create!(klass_id: klass.id, smell_id: smell.id)
    end

    def relative_path(path)
      @revision_path ||= build.locator.revision_path.to_s + '/'
      path.sub(@revision_path, '')
    end
  end
end
