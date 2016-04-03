require "flay"

module Analyzers
  class FlayService < BaseService
    HIGH_DUPLICATION_MASS_THRESHOLD = 25
    BASE_PAIN = 1_500_000
    PAIN_PER_MASS = 100_000

    def call
      flay = Flay.new(flay_options)
      flay.process(*@build.source_locator.paths)

      flay.analyze.each do |item|
        item.locations.each do |location|
          smell = process_location(item, location)

          smell.data[:other_locations] = item.locations.each_with_object(Hash.new) do |other_location, memo|
            next if location == other_location
            file = find_file(other_location.file)
            memo[file.path] = other_location.line
          end
        end
      end
    end

    private

    def process_location(item, location)
      file = find_file(location.file)
      file.metrics[:duplication] = (file.metrics[:duplication] || 0) + item.mass

      make_smell(file,
                 line: location.line,
                 analyzer: "flay".freeze,
                 check_name: item.identical? ? "identical".freeze : "similiar".freeze,
                 pain: calucate_pain(item.mass),
                 data: {mass: item.mass})
    end

    def calucate_pain(mass)
      BASE_PAIN + (mass - HIGH_DUPLICATION_MASS_THRESHOLD) * PAIN_PER_MASS
    end

    def flay_options
      {
        diff: false,
        mass: HIGH_DUPLICATION_MASS_THRESHOLD,
        summary: false,
        verbose: false,
        number: true,
        timeout: 300,
        liberal: false,
        fuzzy: false,
        only: nil
      }
    end
  end
end
