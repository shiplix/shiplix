class RepoConfig
  def initialize(config_path)
    unless File.exist?(config_path)
      Rails.logger.debug("Repo config file does not exists - #{config_path}")
      config_path = Rails.root.join("config/default_shiplix.yml")
    end

    @options = parse_file(config_path).with_indifferent_access
  end

  def [](key)
    @options[key]
  end

  private

  def parse_file(path)
    YAML.load(IO.read(path))
  end
end
